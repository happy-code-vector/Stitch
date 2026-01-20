import Foundation

struct Project: Identifiable, Codable {
    let id: String
    let userId: String
    var name: String
    var type: ProjectType
    var status: ProjectStatus
    var progress: Double
    var totalRows: Int
    var completedRows: Int
    var needleSize: String?
    var stitchType: StitchType?
    var aiCountingEnabled: Bool
    let createdAt: Date
    var updatedAt: Date
    var lastWorked: String?
    
    init(
        id: String = UUID().uuidString,
        userId: String,
        name: String,
        type: ProjectType,
        status: ProjectStatus = .active,
        progress: Double = 0,
        totalRows: Int,
        completedRows: Int = 0,
        needleSize: String? = nil,
        stitchType: StitchType? = nil,
        aiCountingEnabled: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastWorked: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.type = type
        self.status = status
        self.progress = progress
        self.totalRows = totalRows
        self.completedRows = completedRows
        self.needleSize = needleSize
        self.stitchType = stitchType
        self.aiCountingEnabled = aiCountingEnabled
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastWorked = lastWorked
    }
}

enum ProjectType: String, CaseIterable, Codable {
    case scarf = "scarf"
    case beanie = "beanie"
    case sweater = "sweater"
    case mittens = "mittens"
    case blanket = "blanket"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .scarf: return "Scarf"
        case .beanie: return "Beanie"
        case .sweater: return "Sweater"
        case .mittens: return "Mittens"
        case .blanket: return "Blanket"
        case .other: return "Other"
        }
    }
}

enum ProjectStatus: String, CaseIterable, Codable {
    case active = "active"
    case paused = "paused"
    case completed = "completed"
    case archived = "archived"
    
    var displayName: String {
        switch self {
        case .active: return "Active"
        case .paused: return "Paused"
        case .completed: return "Completed"
        case .archived: return "Archived"
        }
    }
}

enum StitchType: String, CaseIterable, Codable {
    case stockinette = "stockinette"
    case garter = "garter"
    case ribbing = "ribbing"
    case cable = "cable"
    case lace = "lace"
    
    var displayName: String {
        switch self {
        case .stockinette: return "Stockinette"
        case .garter: return "Garter"
        case .ribbing: return "Ribbing"
        case .cable: return "Cable"
        case .lace: return "Lace"
        }
    }
}