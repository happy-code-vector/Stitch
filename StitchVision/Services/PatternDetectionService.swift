import Foundation
import Vision
import CoreImage
import UIKit

/// Result of pattern detection
struct PatternDetectionResult {
    let rows: [RowSegment]
    let totalRows: Int
    let confidence: Float
    let errorMessage: String?

    var isSuccess: Bool {
        return errorMessage == nil
    }
}

/// Detects rows in knitting pattern images
class PatternDetectionService {

    // MARK: - Configuration

    /// Minimum row height in pixels
    var minimumRowHeight: CGFloat = 10

    /// Maximum row height in pixels
    var maximumRowHeight: CGFloat = 100

    /// Tolerance for grouping lines (pixels)
    var lineGroupingTolerance: CGFloat = 5

    // MARK: - Singleton

    static let shared = PatternDetectionService()

    private init() {}

    // MARK: - Private Properties

    private let processingQueue = DispatchQueue(label: "com.stitchvision.patterndetection", qos: .userInitiated)

    // MARK: - Public Methods

    /// Detect rows in a pattern image
    /// - Parameter image: The pattern image to analyze
    /// - Parameter completion: Callback with detection result
    func detectRows(in image: UIImage, completion: @escaping (PatternDetectionResult) -> Void) {
        processingQueue.async { [weak self] in
            guard let self = self else { return }

            let result = self.performDetection(on: image)

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    /// Detect rows synchronously (for testing)
    func detectRowsSync(in image: UIImage) -> PatternDetectionResult {
        return performDetection(on: image)
    }

    // MARK: - Private Methods

    private func performDetection(on image: UIImage) -> PatternDetectionResult {
        guard let cgImage = image.cgImage else {
            return PatternDetectionResult(
                rows: [],
                totalRows: 0,
                confidence: 0,
                errorMessage: "Invalid image"
            )
        }

        let startTime = CFAbsoluteTimeGetCurrent()

        // Step 1: Detect contours
        let contourRequest = VNDetectContoursRequest()
        contourRequest.contrastAdjustment = 2.0
        contourRequest.detectsDarkOnLight = true
        contourRequest.maximumImageDimension = 1024

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try handler.perform([contourRequest])

            guard let contours = contourRequest.results?.first else {
                return PatternDetectionResult(
                    rows: [],
                    totalRows: 0,
                    confidence: 0,
                    errorMessage: "No contours detected"
                )
            }

            // Step 2: Analyze contours for horizontal lines
            let horizontalLines = extractHorizontalLines(from: contours, imageHeight: image.size.height)

            // Step 3: Group lines into rows
            let rows = groupLinesIntoRows(horizontalLines, imageHeight: image.size.height)

            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Pattern detection completed in \(String(format: "%.3f", elapsed * 1000))ms")
            print("Detected \(rows.count) rows")

            return PatternDetectionResult(
                rows: rows,
                totalRows: rows.count,
                confidence: calculateConfidence(rows: rows, lineCount: horizontalLines.count),
                errorMessage: nil
            )

        } catch {
            return PatternDetectionResult(
                rows: [],
                totalRows: 0,
                confidence: 0,
                errorMessage: "Detection failed: \(error.localizedDescription)"
            )
        }
    }

    private func extractHorizontalLines(from contours: VNContoursObservation, imageHeight: CGFloat) -> [(y: CGFloat, length: CGFloat)] {
        var horizontalLines: [(y: CGFloat, length: CGFloat)] = []

        let topLevelContours = contours.contourCount

        for i in 0..<topLevelContours {
            guard let contour = try? contours.contour(at: i) else { continue }

            // Check if contour is roughly horizontal
            if let line = analyzeContour(contour, imageHeight: imageHeight) {
                horizontalLines.append(line)
            }
        }

        // Sort by Y position
        return horizontalLines.sorted { $0.y < $1.y }
    }

    private func analyzeContour(_ contour: VNContour, imageHeight: CGFloat) -> (y: CGFloat, length: CGFloat)? {
        let points = contour.normalizedPoints

        guard points.count >= 2 else { return nil }

        // Calculate bounding box
        var minY: CGFloat = CGFloat.infinity
        var maxY: CGFloat = -CGFloat.infinity
        var minX: CGFloat = CGFloat.infinity
        var maxX: CGFloat = -CGFloat.infinity

        for i in 0..<points.count {
            let point = points[i]
            minY = min(minY, CGFloat(point.y))
            maxY = max(maxY, CGFloat(point.y))
            minX = min(minX, CGFloat(point.x))
            maxX = max(maxX, CGFloat(point.x))
        }

        let height = maxY - minY
        let width = maxX - minX

        // Check if it's a horizontal line (height is small relative to width)
        let aspectRatio = height / max(width, 1)
        guard aspectRatio < 0.15 else { return nil }

        // Check minimum length
        guard width > 0.1 else { return nil }

        return (y: (minY + maxY) / 2, length: width)
    }

    private func groupLinesIntoRows(_ lines: [(y: CGFloat, length: CGFloat)], imageHeight: CGFloat) -> [RowSegment] {
        guard !lines.isEmpty else { return [] }

        var rows: [RowSegment] = []
        var currentGroup: [(y: CGFloat, length: CGFloat)] = [lines[0]]

        for i in 1..<lines.count {
            let line = lines[i]
            let lastY = currentGroup.last!.y

            // Check if line is close enough to group
            if abs(line.y - lastY) <= lineGroupingTolerance / imageHeight {
                currentGroup.append(line)
            } else {
                // Create row from current group
                if let row = createRow(from: currentGroup, index: rows.count, imageHeight: imageHeight) {
                    rows.append(row)
                }
                currentGroup = [line]
            }
        }

        // Don't forget the last group
        if let row = createRow(from: currentGroup, index: rows.count, imageHeight: imageHeight) {
            rows.append(row)
        }

        return rows
    }

    private func createRow(from group: [(y: CGFloat, length: CGFloat)], index: Int, imageHeight: CGFloat) -> RowSegment? {
        guard !group.isEmpty else { return nil }

        let yPositions = group.map { $0.y }
        let avgY = yPositions.reduce(0, +) / CGFloat(yPositions.count)
        let minY = yPositions.min()!
        let maxY = yPositions.max()!

        let height = max((maxY - minY) * 2, minimumRowHeight / imageHeight)

        // Validate row height
        let pixelHeight = height * imageHeight
        guard pixelHeight >= minimumRowHeight && pixelHeight <= maximumRowHeight else {
            return nil
        }

        return RowSegment(
            index: index,
            yPosition: avgY,
            height: height,
            stitchCount: nil,
            confidence: min(Float(group.count) / 3.0, 1.0)
        )
    }

    private func calculateConfidence(rows: [RowSegment], lineCount: Int) -> Float {
        guard !rows.isEmpty else { return 0 }

        // More rows and consistent heights = higher confidence
        let avgConfidence = rows.reduce(0) { $0 + $1.confidence } / Float(rows.count)
        let rowHeightVariance = calculateHeightVariance(rows)

        // Lower variance = higher confidence
        let varianceFactor = max(0, 1 - rowHeightVariance)

        return avgConfidence * varianceFactor
    }

    private func calculateHeightVariance(_ rows: [RowSegment]) -> Float {
        guard rows.count > 1 else { return 0 }

        let heights = rows.map { $0.height }
        let avgHeight = heights.reduce(0, +) / CGFloat(heights.count)

        guard avgHeight > 0 else { return 1 }

        let variance = heights.reduce(0) { sum, height in
            sum + pow(height - avgHeight, 2)
        } / CGFloat(heights.count)

        return Float(sqrt(variance) / avgHeight)
    }
}
