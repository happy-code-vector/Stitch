import Foundation
import Combine
import UIKit

/// Unified service for row counting - coordinates optical flow and motion analysis
class RowCountingService: ObservableObject {

    // MARK: - Published Properties

    @Published var rowCount: Int = 0
    @Published var isCounting: Bool = false
    @Published var lastCountTime: Date?
    @Published var countingMode: CountingMode = .automatic

    // MARK: - Enum

    enum CountingMode {
        case automatic  // Using optical flow
        case manual     // User tapping buttons
        case voice      // Voice commands
    }

    // MARK: - Private Properties

    private let opticalFlowDetector = OpticalFlowDetector()
    private let motionAnalyzer = MotionAnalyzer()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init(initialCount: Int = 0) {
        self.rowCount = initialCount
        setupBindings()
    }

    // MARK: - Public Methods

    /// Process a video frame for automatic counting
    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        guard countingMode == .automatic && isCounting else { return }

        // Get optical flow
        guard let flowResult = opticalFlowDetector.processFrame(pixelBuffer) else {
            return
        }

        // Analyze for turn patterns
        if let turnEvent = motionAnalyzer.analyze(flowResult: flowResult) {
            incrementRow(source: .automatic, confidence: turnEvent.confidence)
        }
    }

    /// Start automatic counting
    func startCounting() {
        isCounting = true
        opticalFlowDetector.reset()
    }

    /// Stop automatic counting
    func stopCounting() {
        isCounting = false
    }

    /// Manually increment row count
    func manualIncrement() {
        incrementRow(source: .manual, confidence: 1.0)
        countingMode = .manual
    }

    /// Manually decrement row count
    func manualDecrement() {
        if rowCount > 0 {
            rowCount -= 1
            lastCountTime = Date()
            provideHapticFeedback(style: .light)

            // Reset to automatic after manual adjustment
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.countingMode = .automatic
            }
        }
    }

    /// Voice command increment
    func voiceIncrement() {
        incrementRow(source: .voice, confidence: 1.0)
        countingMode = .voice

        // Reset to automatic after voice command
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.countingMode = .automatic
        }
    }

    /// Reset the counter
    func reset() {
        rowCount = 0
        lastCountTime = nil
        opticalFlowDetector.reset()
        motionAnalyzer.reset()
        countingMode = .automatic
    }

    /// Set the row count directly
    func setRowCount(_ count: Int) {
        rowCount = max(0, count)
        lastCountTime = Date()
    }

    // MARK: - Private Methods

    private enum CountSource {
        case automatic
        case manual
        case voice
    }

    private func incrementRow(source: CountSource, confidence: Float) {
        rowCount += 1
        lastCountTime = Date()

        // Provide haptic feedback
        let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
        switch source {
        case .automatic:
            hapticStyle = confidence > 0.8 ? .medium : .light
        case .manual:
            hapticStyle = .light
        case .voice:
            hapticStyle = .medium
        }

        provideHapticFeedback(style: hapticStyle)

        print("Row \(rowCount) counted via \(source) with confidence \(String(format: "%.2f", confidence))")
    }

    private func provideHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    private func setupBindings() {
        // Bind optical flow detector state
        opticalFlowDetector.$isProcessing
            .receive(on: DispatchQueue.main)
            .assign(to: &$isCounting)
    }

    // MARK: - Debug/Stats

    func getMotionStats() -> (averageX: Float, averageY: Float, sampleCount: Int) {
        return motionAnalyzer.getMotionStats()
    }

    var lastFlowResult: OpticalFlowResult? {
        return opticalFlowDetector.lastFlowResult
    }

    var lastTurnEvent: TurnEvent? {
        return motionAnalyzer.lastTurnEvent
    }
}
