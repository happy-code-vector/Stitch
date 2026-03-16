import Foundation
import UIKit

/// Represents an imported knitting pattern with detected rows
struct KnittingPattern: Codable, Identifiable {
    let id: UUID
    let name: String
    let imageData: Data
    let detectedRows: [RowSegment]
    let totalRows: Int
    let importedAt: Date
    var currentRow: Int
    var completedRows: Set<Int>
    var projectId: UUID?

    init(
        id: UUID = UUID(),
        name: String,
        imageData: Data,
        detectedRows: [RowSegment],
        totalRows: Int,
        importedAt: Date = Date(),
        currentRow: Int = 0,
        completedRows: Set<Int> = [],
        projectId: UUID? = nil
    ) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.detectedRows = detectedRows
        self.totalRows = totalRows
        self.importedAt = importedAt
        self.currentRow = currentRow
        self.completedRows = completedRows
        self.projectId = projectId
    }

    // MARK: - Computed Properties

    var progress: Double {
        guard totalRows > 0 else { return 0 }
        return Double(currentRow) / Double(totalRows)
    }

    var isComplete: Bool {
        return currentRow >= totalRows
    }

    // MARK: - Methods

    mutating func markRowComplete(_ rowIndex: Int) {
        guard rowIndex >= 0 && rowIndex < totalRows else { return }
        completedRows.insert(rowIndex)
        if rowIndex >= currentRow {
            currentRow = rowIndex + 1
        }
    }

    mutating func setCurrentRow(_ row: Int) {
        guard row >= 0 && row <= totalRows else { return }
        currentRow = row
    }

    mutating func reset() {
        currentRow = 0
        completedRows.removeAll()
    }
}
