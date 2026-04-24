import Foundation

struct ProjectModel {
    var id: Int?
    var name: String
    var craftType: String
    var needleSize: String
    var yarnType: String
    var yarnColor: String
    var patternName: String
    var totalRows: Int
    var currentRow: Int
    var status: String

    // PRD Addendum A.2 / B.2 - Rounds & repeat counting
    var countingMode: String        // "rows" | "rounds"
    var currentRound: Int
    var currentRepeat: Int
    var repeatsPerRound: Int?       // e.g. 8 pattern repeats per round
    var stitchMarkerAlert: Bool     // Buzz on each repeat completion

    // Pattern source
    var patternSource: String       // "library" | "upload" | "manual"
    var libraryPatternId: String?
    var patternData: [[String: Any]]? // Array of step objects

    // Project metadata
    var notes: String
    var dueDate: Date?
    var reminderEnabled: Bool
    var createdAt: Date
    var updatedAt: Date

    // Computed: progress ratio (0.0 when totalRows is 0)
    var progress: Double {
        guard totalRows > 0 else { return 0.0 }
        return Double(currentRow) / Double(totalRows)
    }

    init(
        id: Int? = nil,
        name: String = "",
        craftType: String = "",
        needleSize: String = "",
        yarnType: String = "",
        yarnColor: String = "",
        patternName: String = "",
        totalRows: Int = 0,
        currentRow: Int = 0,
        status: String = "active",
        countingMode: String = "rows",
        currentRound: Int = 0,
        currentRepeat: Int = 0,
        repeatsPerRound: Int? = nil,
        stitchMarkerAlert: Bool = true,
        patternSource: String = "manual",
        libraryPatternId: String? = nil,
        patternData: [[String: Any]]? = nil,
        notes: String = "",
        dueDate: Date? = nil,
        reminderEnabled: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.craftType = craftType
        self.needleSize = needleSize
        self.yarnType = yarnType
        self.yarnColor = yarnColor
        self.patternName = patternName
        self.totalRows = totalRows
        self.currentRow = currentRow
        self.status = status
        self.countingMode = countingMode
        self.currentRound = currentRound
        self.currentRepeat = currentRepeat
        self.repeatsPerRound = repeatsPerRound
        self.stitchMarkerAlert = stitchMarkerAlert
        self.patternSource = patternSource
        self.libraryPatternId = libraryPatternId
        self.patternData = patternData
        self.notes = notes
        self.dueDate = dueDate
        self.reminderEnabled = reminderEnabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
