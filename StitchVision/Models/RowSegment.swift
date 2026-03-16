import Foundation

/// Represents a detected row in a knitting pattern
struct RowSegment: Codable, Identifiable {
    let id: UUID
    let index: Int
    let yPosition: CGFloat
    let height: CGFloat
    let stitchCount: Int?
    let confidence: Float

    init(
        id: UUID = UUID(),
        index: Int,
        yPosition: CGFloat,
        height: CGFloat,
        stitchCount: Int? = nil,
        confidence: Float = 1.0
    ) {
        self.id = id
        self.index = index
        self.yPosition = yPosition
        self.height = height
        self.stitchCount = stitchCount
        self.confidence = confidence
    }
}
