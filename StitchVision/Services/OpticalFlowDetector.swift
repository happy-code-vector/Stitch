import Foundation
import Vision
import CoreImage
import Combine
import Accelerate

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
    private var previousPixelBuffer: CVPixelBuffer?
    private var lastAnalysisTime: Date?
    private let ciContext = CIContext()

    // MARK: - Public Methods

    /// Process a new frame and detect motion
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
            // Deep-copy the first frame so the camera can recycle the original
            previousPixelBuffer = copyPixelBuffer(pixelBuffer)
            return nil
        }

        lastAnalysisTime = Date()

        // Deep-copy the current frame before Vision uses it
        guard let currentCopy = copyPixelBuffer(pixelBuffer) else {
            return nil
        }

        // Perform optical flow calculation
        let result = calculateOpticalFlow(previous: previousBuffer, current: currentCopy)

        // Store the deep-copied current frame for next comparison
        previousPixelBuffer = currentCopy

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

    /// Create a deep copy of a CVPixelBuffer that we own exclusively.
    /// Camera pixel buffers belong to the capture session's buffer pool and
    /// can be recycled/overwritten even while we hold a Swift reference.
    private func copyPixelBuffer(_ source: CVPixelBuffer) -> CVPixelBuffer? {
        let width = CVPixelBufferGetWidth(source)
        let height = CVPixelBufferGetHeight(source)
        let format = CVPixelBufferGetPixelFormatType(source)

        guard width > 0, height > 0 else { return nil }

        var pixelBuffer: CVPixelBuffer?
        let attrs: [String: Any] = [
            kCVPixelBufferIOSurfacePropertiesKey as String: [:] as [String: Any]
        ]

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width, height,
            format,
            attrs as CFDictionary,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let copy = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(source, .readOnly)
        CVPixelBufferLockBaseAddress(copy, [])

        defer {
            CVPixelBufferUnlockBaseAddress(copy, [])
            CVPixelBufferUnlockBaseAddress(source, .readOnly)
        }

        guard let srcBase = CVPixelBufferGetBaseAddress(source),
              let dstBase = CVPixelBufferGetBaseAddress(copy) else {
            return nil
        }

        let srcBytesPerRow = CVPixelBufferGetBytesPerRow(source)
        let dstBytesPerRow = CVPixelBufferGetBytesPerRow(copy)

        if srcBytesPerRow == dstBytesPerRow {
            // Fast path — identical stride, memcpy the whole buffer
            let totalBytes = srcBytesPerRow * height
            memcpy(dstBase, srcBase, totalBytes)
        } else {
            // Row-by-row copy to handle stride mismatch
            let copyBytes = min(srcBytesPerRow, dstBytesPerRow)
            for y in 0..<height {
                let srcRow = srcBase.advanced(by: y * srcBytesPerRow)
                let dstRow = dstBase.advanced(by: y * dstBytesPerRow)
                memcpy(dstRow, srcRow, copyBytes)
            }
        }

        return copy
    }

    private func calculateOpticalFlow(previous: CVPixelBuffer, current: CVPixelBuffer) -> OpticalFlowResult {
        let startTime = CFAbsoluteTimeGetCurrent()

        let handler = VNSequenceRequestHandler()
        let flowRequest = VNGenerateOpticalFlowRequest(targetedCVPixelBuffer: current)

        do {
            try handler.perform([flowRequest], on: previous)

            guard let flowObservation = flowRequest.results?.first as? VNPixelBufferObservation else {
                return createEmptyResult()
            }

            let flowBuffer = flowObservation.pixelBuffer
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
        let width = CVPixelBufferGetWidth(flowBuffer)
        let height = CVPixelBufferGetHeight(flowBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(flowBuffer)

        guard width > 0, height > 0, bytesPerRow > 0 else {
            return createEmptyResult()
        }

        CVPixelBufferLockBaseAddress(flowBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(flowBuffer, .readOnly) }

        guard let baseAddress = CVPixelBufferGetBaseAddress(flowBuffer) else {
            return createEmptyResult()
        }

        let pointer = baseAddress.assumingMemoryBound(to: Float32.self)
        let strideElements = bytesPerRow / MemoryLayout<Float32>.size

        // Calculate ROI pixel bounds (clamped to buffer dimensions)
        let roiStartX = max(0, min(Int(Float(width) * Float(regionOfInterest.origin.x)), width - 1))
        let roiStartY = max(0, min(Int(Float(height) * Float(regionOfInterest.origin.y)), height - 1))
        let roiWidth = min(Int(Float(width) * Float(regionOfInterest.width)), width - roiStartX)
        let roiHeight = min(Int(Float(height) * Float(regionOfInterest.height)), height - roiStartY)

        guard roiWidth > 0, roiHeight > 0 else {
            return createEmptyResult()
        }

        let floatsPerPixel = 2

        var totalMotionX: Float = 0
        var totalMotionY: Float = 0
        var validPixels: Int = 0
        var totalConfidence: Float = 0

        for y in stride(from: roiStartY, to: roiStartY + roiHeight, by: 2) {
            for x in stride(from: roiStartX, to: roiStartX + roiWidth, by: 2) {
                let offset = y * strideElements + x * floatsPerPixel

                guard offset + 1 < strideElements * height else { continue }

                let motionX = pointer[offset]
                let motionY = pointer[offset + 1]

                guard motionX.isFinite, motionY.isFinite else { continue }
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
