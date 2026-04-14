import Foundation
import Combine

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}

@MainActor
class StitchBotService: ObservableObject {
    static let shared = StitchBotService()

    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Usage tracking
    @Published var questionsUsedThisMonth: Int = 0
    @Published var questionsRemaining: Int = 10

    private let freeQuestionsPerMonth = 10
    let proDailyLimit = 50
    private let usageKey = "stitchbot_questions_used"
    private let lastResetKey = "stitchbot_last_reset"
    private let dailyUsageKey = "stitchbot_daily_count"
    private let dailyResetKey = "stitchbot_daily_date"

    private let apiKey: String = Bundle.main.infoDictionary?["GeminiAPIKey"] as? String ?? ""

    private init() {
        checkAndResetMonthlyUsage()
    }

    // MARK: - Usage Management

    private func checkAndResetMonthlyUsage() {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)

        if let lastResetData = UserDefaults.standard.object(forKey: lastResetKey) as? [String: Int],
           let savedMonth = lastResetData["month"],
           let savedYear = lastResetData["year"],
           (savedYear < currentYear || (savedYear == currentYear && savedMonth < currentMonth)) {
            // New month - reset counter
            questionsUsedThisMonth = 0
            saveUsage()
        } else {
            questionsUsedThisMonth = UserDefaults.standard.integer(forKey: usageKey)
        }

        updateRemainingQuestions()
    }

    private func updateRemainingQuestions() {
        let isPro = SubscriptionManager.shared.isPro
        questionsRemaining = isPro ? -1 : max(0, freeQuestionsPerMonth - questionsUsedThisMonth)
    }

    private func saveUsage() {
        UserDefaults.standard.set(questionsUsedThisMonth, forKey: usageKey)

        let calendar = Calendar.current
        let now = Date()
        let lastReset: [String: Int] = [
            "month": calendar.component(.month, from: now),
            "year": calendar.component(.year, from: now)
        ]
        UserDefaults.standard.set(lastReset, forKey: lastResetKey)

        updateRemainingQuestions()
    }

    func canAskQuestion() -> Bool {
        let isPro: Bool
        if Thread.isMainThread {
            isPro = SubscriptionManager.shared.isPro
        } else {
            isPro = DispatchQueue.main.sync { SubscriptionManager.shared.isPro }
        }

        if isPro {
            // Pro: check daily cap
            return todayUsageCount() < proDailyLimit
        } else {
            // Free: check monthly cap
            return questionsRemaining > 0
        }
    }

    func todayUsageCount() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let savedDate = UserDefaults.standard.object(forKey: dailyResetKey) as? Date

        if savedDate == nil || !calendar.isDate(savedDate!, inSameDayAs: today) {
            // New day — reset
            UserDefaults.standard.set(0, forKey: dailyUsageKey)
            UserDefaults.standard.set(today, forKey: dailyResetKey)
            return 0
        }

        return UserDefaults.standard.integer(forKey: dailyUsageKey)
    }

    private func incrementDailyUsage() {
        let count = todayUsageCount() + 1
        UserDefaults.standard.set(count, forKey: dailyUsageKey)
    }

    // MARK: - Chat

    func sendMessage(_ text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        // Check if user can ask questions
        guard canAskQuestion() else {
            let isPro = SubscriptionManager.shared.isPro
            errorMessage = isPro
                ? "Daily limit of \(proDailyLimit) questions reached. Come back tomorrow!"
                : "You've used all your free questions this month. Upgrade to Pro for more access."
            return
        }

        // Add user message
        messages.append(ChatMessage(content: text, isUser: true))
        isLoading = true
        errorMessage = nil

        // Build conversation context (last 5 messages for context)
        let recentMessages = messages.suffix(5)
        var conversationHistory: [[String: String]] = []
        for msg in recentMessages {
            conversationHistory.append([
                "role": msg.isUser ? "user" : "model",
                "content": msg.content
            ])
        }

        // Call Gemini API
        do {
            let response = try await callGeminiAPI(question: text, history: conversationHistory)

            messages.append(ChatMessage(content: response, isUser: false))
            questionsUsedThisMonth += 1
            incrementDailyUsage()
            saveUsage()
            isLoading = false
        } catch {
            errorMessage = "Failed to get response. Please try again."
            isLoading = false
        }
    }

    private func callGeminiAPI(question: String, history: [[String: String]]) async throws -> String {
        let systemPrompt = """
        You are StitchBot, an expert knitting and crochet instructor. Answer questions about stitches, techniques, patterns, and troubleshooting. Keep answers under 150 words. Be friendly and encouraging. If you don't know something, say "I'm not sure about that specific technique — consult your pattern or a local yarn shop."

        Focus on being helpful and practical. Use simple language that beginners can understand.
        """

        var contents: [[String: Any]] = []

        // Add conversation history
        for msg in history {
            contents.append([
                "role": msg["role"] ?? "user",
                "parts": [["text": msg["content"] ?? ""]]
            ])
        }

        // Add current question with system prompt
        if contents.isEmpty {
            contents.append([
                "role": "user",
                "parts": [["text": "\(systemPrompt)\n\n\(question)"]]
            ])
        } else {
            contents.append([
                "role": "user",
                "parts": [["text": question]]
            ])
        }

        let requestBody: [String: Any] = [
            "contents": contents,
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 200
            ]
        ]

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=\(apiKey)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            throw URLError(.cannotDecodeContentData)
        }

        return text
    }

    func clearConversation() {
        messages = []
    }
}
