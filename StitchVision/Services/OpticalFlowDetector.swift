import Foundation
import CoreImage
import Combine

/// Result of motion analysis
struct OpticalFlowResult {
    let averageMotionX: Float
    let averageMotionY: Float
    let motionMagnitude: Float
    let confidence: Float
    let timestamp: Date
}

/// Detects motion patterns using frame differencing.
/// Compares consecutive camera frames to detect horizontal knitting motion
/// without using Vision's VNGenerateOpticalFlowRequest (which crashes).
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

    private var previousFrameData: [UInt8]?
    private var previousWidth: Int = 0
    private var previousHeight: Int = 0
    private var lastAnalysisTime: Date?
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])

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

        // Convert to BGRA bytes we own
        guard let (frameData, width, height) = pixelBufferToBGRA(pixelBuffer) else {
            return nil
        }

        // Need previous frame for comparison
        guard let prevData = previousFrameData,
              previousWidth == width, previousHeight == height else {
            previousFrameData = frameData
            previousWidth = width
            previousHeight = height
            return nil
        }

        lastAnalysisTime = Date()

        // Compute motion
        let result = computeMotion(
            previous: prevData,
            current: frameData,
            width: width,
            height: height
        )

        // Store current frame for next comparison
        previousFrameData = frameData

        DispatchQueue.main.async {
            self.lastFlowResult = result
        }

        return result
    }

    /// Reset the detector (clear previous frame)
    func reset() {
        previousFrameData = nil
        previousWidth = 0
        previousHeight = 0
        lastAnalysisTime = nil
        DispatchQueue.main.async {
            self.lastFlowResult = nil
        }
    }

    // MARK: - Private Methods

    /// Convert any CVPixelBuffer to owned BGRA bytes via CIContext.
    /// Returns nil if conversion fails.
    private func pixelBufferToBGRA(_ pixelBuffer: CVPixelBuffer) -> (data: [UInt8], width: Int, height: Int)? {
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        guard width > 0, height > 0 else { return nil }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // Create a BGRA bitmap we own
        let bytesPerRow = width * 4
        var bgraData = [UInt8](repeating: 0, count: bytesPerRow * height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        ciContext.render(ciImage,
                         toBitmap: &bgraData,
                         rowBytes: bytesPerRow,
                         bounds: CGRect(x: 0, y: 0, width: width, height: height),
                         format: .BGRA8,
                         colorSpace: colorSpace)

        return (bgraData, width, height)
    }

    /// Compare two BGRA frames and detect horizontal motion.
    /// Divides the ROI into left/right halves — the imbalance reveals direction.
    private func computeMotion(
        previous: [UInt8],
        current: [UInt8],
        width: Int,
        height: Int
    ) -> OpticalFlowResult {
        let bytesPerRow = width * 4

        // Calculate ROI bounds (clamped)
        let roiStartX = max(0, min(Int(Float(width) * Float(regionOfInterest.origin.x)), width - 1))
        let roiStartY = max(0, min(Int(Float(height) * Float(regionOfInterest.origin.y)), height - 1))
        let roiWidth = min(Int(Float(width) * Float(regionOfInterest.width)), width - roiStartX)
        let roiHeight = min(Int(Float(height) * Float(regionOfInterest.height)), height - roiStartY)

        guard roiWidth > 4, roiHeight > 4 else {
            return createEmptyResult()
        }

        let halfWidth = roiStartX + roiWidth / 2
        let halfHeight = roiStartY + roiHeight / 2

        var leftChange: Float = 0
        var rightChange: Float = 0
        var topChange: Float = 0
        var bottomChange: Float = 0
        var totalChange: Float = 0
        var activePixels: Int = 0

        // Sample every 2nd pixel for performance, compare luminance
        for y in stride(from: roiStartY, to: roiStartY + roiHeight, by: 2) {
            let rowOffset = y * bytesPerRow
            for x in stride(from: roiStartX, to: roiStartX + roiWidth, by: 2) {
                let px = rowOffset + x * 4

                // BGRA luminance difference (using green channel as proxy — fast)
                let diff = abs(Int(current[px + 1]) - Int(previous[px + 1]))

                if diff > 12 { // noise threshold
                    let fDiff = Float(diff)
                    totalChange += fDiff
                    activePixels += 1

                    // Horizontal: left vs right half
                    if x < halfWidth {
                        leftChange += fDiff
                    } else {
                        rightChange += fDiff
                    }

                    // Vertical: top vs bottom half
                    if y < halfHeight {
                        topChange += fDiff
                    } else {
                        bottomChange += fDiff
                    }
                }
            }
        }

        // Compute direction from imbalance
        let hTotal = leftChange + rightChange
        let vTotal = topChange + bottomChange

        let motionX = hTotal > 0 ? (rightChange - leftChange) / hTotal * 5.0 : 0
        let motionY = vTotal > 0 ? (bottomChange - topChange) / vTotal * 5.0 : 0
        let motionMagnitude = sqrt(motionX * motionX + motionY * motionY)
        let confidence = min(totalChange / Float(max(1, activePixels) * 80), 1.0)

        return OpticalFlowResult(
            averageMotionX: motionX,
            averageMotionY: motionY,
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
