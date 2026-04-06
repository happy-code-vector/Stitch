import Foundation
import Vision
import CoreImage
import Combine

/// Result of optical flow analysis
struct OpticalFlowResult {
    let averageMotionX: Float
    let averageMotionY: Float
    let motionMagnitude: Float
    let confidence: Float
    let timestamp: Date
}

/// Detects motion patterns using Apple Vision optical flow
class OpticalFlowDetector: ObservableObject {

    // MARK: - Published Properties

    @Published var isProcessing: Bool = false
    @Published var lastFlowResult: OpticalFlowResult?

    // MARK: - Configuration

    /// Region of interest for analysis (normalized 0-1)
    var regionOfInterest: CGRect = CGRect(x: 0.2, y: 0.3, width: 0.6, height: 0.4)

    /// Minimum time between frame analyses (seconds)
    var analysisThrottle: TimeInterval = 0.1 // 10 FPS max

    // MARK: - Private Properties

    private let processingQueue = DispatchQueue(label: "com.stitchvision.opticalflow", qos: .userInitiated)
    private let sequenceHandler = VNSequenceRequestHandler()
    private var previousPixelBuffer: CVPixelBuffer?
    private var lastAnalysisTime: Date?

    // MARK: - Public Methods

    /// Process a new frame and detect motion
    /// - Parameter pixelBuffer: The current video frame
    /// - Returns: Optical flow result if enough time has passed since last analysis
    func processFrame(_ pixelBuffer: CVPixelBuffer) -> OpticalFlowResult? {
        // Throttle analysis
        if let lastTime = lastAnalysisTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            if elapsed < analysisThrottle {
                return nil
            }
        }

        // Need previous frame for comparison
        guard let previousBuffer = previousPixelBuffer else {
            previousPixelBuffer = pixelBuffer
            return nil
        }

        lastAnalysisTime = Date()

        // Perform optical flow calculation
        let result = calculateOpticalFlow(previous: previousBuffer, current: pixelBuffer)

        // Store current frame for next comparison
        previousPixelBuffer = pixelBuffer

        DispatchQueue.main.async {
            self.lastFlowResult = result
        }

        return result
    }

    /// Reset the detector (clear previous frame)
    func reset() {
        previousPixelBuffer = nil
        lastAnalysisTime = nil
        DispatchQueue.main.async {
            self.lastFlowResult = nil
        }
    }

    // MARK: - Private Methods

    private func calculateOpticalFlow(previous: CVPixelBuffer, current: CVPixelBuffer) -> OpticalFlowResult {
        let startTime = CFAbsoluteTimeGetCurrent()

        // Create optical flow request targeting the current frame
        let flowRequest = VNGenerateOpticalFlowRequest(targetedCVPixelBuffer: current)

        do {
            // Perform optical flow on the previous frame; Vision compares it against the target
            try sequenceHandler.perform([flowRequest], on: previous)

            // Get flow results — pixelBuffer on VNPixelBufferObservation is non-optional
            guard let flowObservation = flowRequest.results?.first as? VNPixelBufferObservation else {
                return createEmptyResult()
            }

            let flowBuffer = flowObservation.pixelBuffer

            // Analyze the flow vectors in ROI
            let result = analyzeFlowVectors(flowBuffer)

            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Optical flow processed in \(String(format: "%.3f", elapsed * 1000))ms")

            return result

        } catch {
            print("Optical flow error: \(error)")
            return createEmptyResult()
        }
    }

    private func analyzeFlowVectors(_ flowBuffer: CVPixelBuffer) -> OpticalFlowResult {
        CVPixelBufferLockBaseAddress(flowBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(flowBuffer, .readOnly) }

        let width = CVPixelBufferGetWidth(flowBuffer)
        let height = CVPixelBufferGetHeight(flowBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(flowBuffer)

        guard let baseAddress = CVPixelBufferGetBaseAddress(flowBuffer) else {
            return createEmptyResult()
        }

        let pointer = baseAddress.assumingMemoryBound(to: Float32.self)

        // Calculate ROI pixel bounds
        let roiStartX = Int(Float(width) * Float(regionOfInterest.origin.x))
        let roiStartY = Int(Float(height) * Float(regionOfInterest.origin.y))
        let roiWidth = Int(Float(width) * Float(regionOfInterest.width))
        let roiHeight = Int(Float(height) * Float(regionOfInterest.height))

        var totalMotionX: Float = 0
        var totalMotionY: Float = 0
        var validPixels: Int = 0
        var totalConfidence: Float = 0

        // Sample pixels in ROI (skip every other pixel for performance)
        for y in stride(from: roiStartY, to: roiStartY + roiHeight, by: 2) {
            for x in stride(from: roiStartX, to: roiStartX + roiWidth, by: 2) {
                let offset = y * (bytesPerRow / MemoryLayout<Float32>.size) + x * 2

                let motionX = pointer[offset]
                let motionY = pointer[offset + 1]

                // Filter out invalid/zero motion
                let magnitude = sqrt(motionX * motionX + motionY * motionY)
                guard magnitude > 0.1 && magnitude < 50 else { continue }

                totalMotionX += motionX
                totalMotionY += motionY
                totalConfidence += min(magnitude / 10.0, 1.0)
                validPixels += 1
            }
        }

        let averageMotionX = validPixels > 0 ? totalMotionX / Float(validPixels) : 0
        let averageMotionY = validPixels > 0 ? totalMotionY / Float(validPixels) : 0
        let motionMagnitude = sqrt(averageMotionX * averageMotionX + averageMotionY * averageMotionY)
        let confidence = validPixels > 0 ? totalConfidence / Float(validPixels) : 0

        return OpticalFlowResult(
            averageMotionX: averageMotionX,
            averageMotionY: averageMotionY,
            motionMagnitude: motionMagnitude,
            confidence: confidence,
            timestamp: Date()
        )
    }

    private func createEmptyResult() -> OpticalFlowResult {
        return OpticalFlowResult(
            averageMotionX: 0,
            averageMotionY: 0,
            motionMagnitude: 0,
            confidence: 0,
            timestamp: Date()
        )
    }
}
