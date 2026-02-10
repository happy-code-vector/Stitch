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
        status: String = "active"
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
    }
}
