import Foundation
import UIKit
import Combine

/// Analysis types for AI Coach
enum CoachAnalysisType {
    case tension
    case mistake
    case context
    case proximity
}

/// AI Coach response
struct CoachResponse {
    let type: CoachAnalysisType
    let message: String
    let severity: CoachSeverity?
    let timestamp: Date
}

enum CoachSeverity: String {
    case info = "info"
    case minor = "minor"
    case moderate = "moderate"
    case critical = "critical"
}

/// AI Coach Pro service (uses Gemini for analysis)
class AICoachProService: ObservableObject {

    // MARK: - Published Properties

    @Published var lastResponse: CoachResponse?
    @Published var isAnalyzing: Bool = false
    @Published var errorMessage: String?

    // MARK: - Configuration

    /// Minimum time between analyses (throttling)
    var analysisThrottle: TimeInterval = 30.0

    /// Maximum analyses per day (covers Stitch Doctor + Tension Check)
    var maxAnalysesPerDay: Int = 20

    // MARK: - Private Properties

    private let geminiService: GeminiVisionService
    private var lastAnalysisTime: Date?
    private var todayAnalysisCount: Int = 0
    private var lastAnalysisDate: Date = Date()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Singleton

    static let shared = AICoachProService()

    private init() {
        self.geminiService = GeminiVisionService()
    }

    // MARK: - Public Methods

    /// Analyze tension in knitting
    @MainActor func analyzeTension(image: UIImage, completion: @escaping (CoachResponse?) -> Void) {
        guard canAnalyze() else {
            completion(nil)
            return
        }

        analyze(image: image, type: .tension, completion: completion)
    }

    /// Detect mistakes in knitting
    @MainActor func detectMistakes(image: UIImage, completion: @escaping (CoachResponse?) -> Void) {
        guard canAnalyze() else {
            completion(nil)
            return
        }

        analyze(image: image, type: .mistake, completion: completion)
    }

    /// Get contextual coaching advice
    func getContextualAdvice(
        currentRow: Int,
        totalRows: Int,
        lastTip: String?,
        completion: @escaping (CoachResponse?) -> Void
    ) {
        let prompt = """
        You are StitchBot, a friendly knitting and crochet tutor inside a row-counter app. \
        The crafter is on row \(currentRow) of \(totalRows) (\(Int(Double(currentRow) / Double(totalRows) * 100))% complete).
        \(lastTip != nil ? "Last tip you gave: \(lastTip!). Don't repeat it." : "")

        Give ONE brief, specific tip or encouragement (1-2 sentences). \
        Vary your advice: technique tips, tension reminders, posture hints, fun knitting facts, \
        or milestone celebrations. Be warm and helpful, like a crafty friend.
        """

        let service = geminiService
        let percentage = Int(Double(currentRow) / Double(totalRows) * 100)
        Task { @MainActor in
            do {
                let result = try await service.sendTextPrompt(prompt)
                let response = CoachResponse(
                    type: .context,
                    message: result,
                    severity: .info,
                    timestamp: Date()
                )
                self.lastResponse = response
                completion(response)
            } catch {
                let fallback = CoachResponse(
                    type: .context,
                    message: "You're \(percentage)% done — keep going!",
                    severity: .info,
                    timestamp: Date()
                )
                self.lastResponse = fallback
                completion(fallback)
            }
        }
    }

    /// Check proximity to markers
    func checkProximity(currentRow: Int, markers: [String: Int]) -> CoachResponse? {
        for (name, markerRow) in markers {
            let distance = markerRow - currentRow

            if distance == 5 {
                return CoachResponse(
                    type: .proximity,
                    message: "5 rows until \(name)",
                    severity: .info,
                    timestamp: Date()
                )
            }

            if distance == 1 {
                return CoachResponse(
                    type: .proximity,
                    message: "Next row is \(name)!",
                    severity: .minor,
                    timestamp: Date()
                )
            }
        }

        return nil
    }

    // MARK: - Private Methods

    @MainActor private func canAnalyze() -> Bool {
        // Check Pro subscription
        guard SubscriptionManager.shared.canUseAICoach else {
            errorMessage = "AI Coach is a Pro feature. Please upgrade to use."
            return false
        }

        // Check throttle
        if let lastTime = lastAnalysisTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            if elapsed < analysisThrottle {
                return false
            }
        }

        // Check daily limit
        let calendar = Calendar.current
        if !calendar.isDate(lastAnalysisDate, inSameDayAs: Date()) {
            todayAnalysisCount = 0
            lastAnalysisDate = Date()
        }

        if todayAnalysisCount >= maxAnalysesPerDay {
            errorMessage = "Daily analysis limit reached. Try again tomorrow."
            return false
        }

        return true
    }

    private func analyze(
        image: UIImage,
        type: CoachAnalysisType,
        completion: @escaping (CoachResponse?) -> Void
    ) {
        isAnalyzing = true
        lastAnalysisTime = Date()
        todayAnalysisCount += 1

        let prompt = getPrompt(for: type)

        // Use Gemini service for analysis
        geminiService.analyzeImage(image, prompt: prompt) { result in
            DispatchQueue.main.async {
                self.isAnalyzing = false

                switch result {
                case .success(let response):
                    let coachResponse = CoachResponse(
                        type: type,
                        message: response,
                        severity: self.determineSeverity(from: response, type: type),
                        timestamp: Date()
                    )
                    self.lastResponse = coachResponse
                    completion(coachResponse)

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(nil)
                }
            }
        }
    }

    private func getPrompt(for type: CoachAnalysisType) -> String {
        switch type {
        case .tension:
            return """
            You are StitchBot, a friendly knitting and crochet tutor examining a crafter's work. \
            Analyze the stitch tension in this image. \
            Rate it as: even, loose, or tight. If uneven, point out which area looks different. \
            Give a specific tip to fix any tension issues (e.g., hand positioning, yarn hold, needle size). \
            Keep it to 2-3 sentences. Be encouraging — uneven tension is normal while learning.
            """

        case .mistake:
            return """
            You are StitchBot, a friendly knitting and crochet tutor examining a crafter's work. \
            Look for any errors: dropped stitches, accidental yarn overs, wrong stitch types, \
            twisted stitches, or extra/missing stitches. \
            If you find an issue, explain what happened and how to fix it (tink back, drop down, etc.). \
            Rate severity: minor (easy fix), moderate (needs attention), or critical (frog back needed). \
            Keep it to 2-3 sentences. Mistakes happen to everyone — be helpful, not harsh.
            """

        case .context:
            return "Give brief encouragement and a specific tip for a crafter."

        case .proximity:
            return "Alert about approaching marker."
        }
    }

    private func determineSeverity(from response: String, type: CoachAnalysisType) -> CoachSeverity {
        let lowercased = response.lowercased()

        if lowercased.contains("critical") || lowercased.contains("severe") {
            return .critical
        } else if lowercased.contains("moderate") {
            return .moderate
        } else if lowercased.contains("minor") || lowercased.contains("loose") || lowercased.contains("tight") {
            return .minor
        } else {
            return .info
        }
    }
}

// MARK: - GeminiVisionService Extension

extension GeminiVisionService {
    /// Analyze an image with a custom prompt using Gemini. Calls the real API.
    func analyzeImage(_ image: UIImage, prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            do {
                let result = try await analyzeWithPrompt(image: image, prompt: prompt)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
