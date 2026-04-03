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

    /// Maximum analyses per day
    var maxAnalysesPerDay: Int = 50

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
        You are a knitting coach. The user is on row \(currentRow) of \(totalRows).
        \(lastTip != nil ? "Last tip given: \(lastTip!)" : "")

        Give a brief (1-2 sentence) encouraging message or specific advice for their current progress.
        """

        // For context, we don't need an image, just use the prompt
        Task {
            // This would call Gemini with text-only prompt
            let response = CoachResponse(
                type: .context,
                message: "Great progress! You're \(Int(Double(currentRow) / Double(totalRows) * 100))% done. Keep your tension consistent.",
                severity: .info,
                timestamp: Date()
            )

            DispatchQueue.main.async {
                self.lastResponse = response
                completion(response)
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
            Analyze the stitch tension in this knitting sample.
            Rate the tension as: even, loose, or tight.
            If uneven, identify which area has issues.
            Keep response brief (2-3 sentences max).
            """

        case .mistake:
            return """
            Detect any knitting errors in this image.
            Look for: dropped stitches, accidental yarn overs, wrong stitch types.
            List severity: minor, moderate, or critical.
            Keep response brief (2-3 sentences max).
            """

        case .context:
            return "Give brief encouragement for a knitter."

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
    func analyzeImage(_ image: UIImage, prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        // This would be implemented to call Gemini API with custom prompt
        // For now, return a placeholder
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success("Tension looks even. No significant issues detected."))
        }
    }
}
