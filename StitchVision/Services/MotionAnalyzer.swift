import Foundation
import Combine

/// Represents a detected turn (row completion)
struct TurnEvent {
    let timestamp: Date
    let confidence: Float
    let direction: TurnDirection
}

enum TurnDirection {
    case leftToRight
    case rightToLeft
}

/// Analyzes optical flow results to detect knitting turn patterns
class MotionAnalyzer: ObservableObject {

    // MARK: - Published Properties

    @Published var lastTurnEvent: TurnEvent?
    @Published var turnCount: Int = 0
    @Published var isAnalyzing: Bool = false

    // MARK: - Configuration

    /// Minimum horizontal motion threshold to consider (pixels per frame)
    var motionThreshold: Float = 1.5

    /// Required confidence level to trigger turn detection
    var confidenceThreshold: Float = 0.4

    /// Minimum time between turn detections (seconds) — fast knitters can do
    /// a row in ~3s, so 2s debounce allows detection while filtering noise
    var turnDebounceTime: TimeInterval = 2.0

    /// Number of consecutive frames with consistent motion to confirm turn
    var confirmationFrames: Int = 3

    // MARK: - Private Properties

    private var motionHistory: [MotionSample] = []
    private let maxHistorySize: Int = 30 // ~3 seconds at 10 FPS
    private var lastTurnTime: Date?
    private var pendingTurnDirection: TurnDirection?
    private var confirmationCount: Int = 0

    // MARK: - Structs

    private struct MotionSample {
        let motionX: Float
        let motionY: Float
        let magnitude: Float
        let timestamp: Date
    }

    // MARK: - Public Methods

    /// Analyze an optical flow result for turn patterns
    /// - Parameter flowResult: The optical flow result from detector
    /// - Returns: A turn event if a turn was detected
    func analyze(flowResult: OpticalFlowResult) -> TurnEvent? {
        let sample = MotionSample(
            motionX: flowResult.averageMotionX,
            motionY: flowResult.averageMotionY,
            magnitude: flowResult.motionMagnitude,
            timestamp: flowResult.timestamp
        )

        // Add to history
        motionHistory.append(sample)
        if motionHistory.count > maxHistorySize {
            motionHistory.removeFirst()
        }

        // Check for turn pattern
        let turnEvent = detectTurn(sample: sample, confidence: flowResult.confidence)

        return turnEvent
    }

    /// Reset the analyzer state
    func reset() {
        motionHistory.removeAll()
        lastTurnTime = nil
        pendingTurnDirection = nil
        confirmationCount = 0
        turnCount = 0
        DispatchQueue.main.async {
            self.lastTurnEvent = nil
        }
    }

    // MARK: - Private Methods

    private func detectTurn(sample: MotionSample, confidence: Float) -> TurnEvent? {
        // Check debounce
        if let lastTurn = lastTurnTime {
            let elapsed = sample.timestamp.timeIntervalSince(lastTurn)
            if elapsed < turnDebounceTime {
                return nil
            }
        }

        // Check confidence threshold
        guard confidence >= confidenceThreshold else {
            // Reset confirmation if confidence drops
            confirmationCount = 0
            pendingTurnDirection = nil
            return nil
        }

        // Determine motion direction
        let isRightward = sample.motionX > motionThreshold
        let isLeftward = sample.motionX < -motionThreshold
        let isMostlyHorizontal = abs(sample.motionX) > abs(sample.motionY) * 1.0

        guard isMostlyHorizontal && (isRightward || isLeftward) else {
            // Reset confirmation if motion isn't clearly horizontal
            confirmationCount = max(0, confirmationCount - 1)
            return nil
        }

        let currentDirection: TurnDirection = isRightward ? .leftToRight : .rightToLeft

        // Check if direction is consistent with pending turn
        if let pending = pendingTurnDirection {
            if pending == currentDirection {
                confirmationCount += 1

                // Check if we have enough confirmation frames
                if confirmationCount >= confirmationFrames {
                    // Turn confirmed!
                    let event = TurnEvent(
                        timestamp: sample.timestamp,
                        confidence: confidence,
                        direction: currentDirection
                    )

                    lastTurnTime = sample.timestamp
                    turnCount += 1

                    DispatchQueue.main.async {
                        self.lastTurnEvent = event
                    }

                    // Reset for next turn
                    confirmationCount = 0
                    pendingTurnDirection = nil

                    return event
                }
            } else {
                // Direction changed, start over
                pendingTurnDirection = currentDirection
                confirmationCount = 1
            }
        } else {
            // Start tracking potential turn
            pendingTurnDirection = currentDirection
            confirmationCount = 1
        }

        return nil
    }

    /// Get motion statistics for debugging/display
    func getMotionStats() -> (averageX: Float, averageY: Float, sampleCount: Int) {
        guard !motionHistory.isEmpty else {
            return (averageX: 0, averageY: 0, sampleCount: 0)
        }

        let sumX = motionHistory.reduce(0) { $0 + $1.motionX }
        let sumY = motionHistory.reduce(0) { $0 + $1.motionY }

        return (
            averageX: sumX / Float(motionHistory.count),
            averageY: sumY / Float(motionHistory.count),
            sampleCount: motionHistory.count
        )
    }
}
