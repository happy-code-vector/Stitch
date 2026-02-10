import Foundation

struct SessionModel {
    var id: Int?
    var projectId: Int?
    var rowsKnit: Int
    var timeSpent: Int
    var startTime: String
    var endTime: String
    
    init(
        id: Int? = nil,
        projectId: Int? = nil,
        rowsKnit: Int = 0,
        timeSpent: Int = 0,
        startTime: String = "",
        endTime: String = ""
    ) {
        self.id = id
        self.projectId = projectId
        self.rowsKnit = rowsKnit
        self.timeSpent = timeSpent
        self.startTime = startTime
        self.endTime = endTime
    }
}
