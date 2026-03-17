import Foundation
import CoreData

// MARK: - UserProfileEntity

@objc(UserProfileEntity)
public class UserProfileEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var craftType: String?
    @NSManaged public var skillLevel: String?
    @NSManaged public var struggles: String?
    @NSManaged public var habitFrequency: String?
    @NSManaged public var goal: String?
    @NSManaged public var isPro: Bool
    @NSManaged public var hasCompletedOnboarding: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
}

extension UserProfileEntity {
    static func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
        return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
    }
}

// MARK: - ProjectEntity

@objc(ProjectEntity)
public class ProjectEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var userId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var craftType: String?
    @NSManaged public var needleSize: String?
    @NSManaged public var yarnType: String?
    @NSManaged public var yarnColor: String?
    @NSManaged public var patternName: String?
    @NSManaged public var totalRows: Int32
    @NSManaged public var currentRow: Int32
    @NSManaged public var status: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
}

extension ProjectEntity {
    static func fetchRequest() -> NSFetchRequest<ProjectEntity> {
        return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
    }
}

// MARK: - SessionEntity

@objc(SessionEntity)
public class SessionEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var projectId: UUID?
    @NSManaged public var rowsKnit: Int32
    @NSManaged public var timeSpent: Int32
    @NSManaged public var startTime: Date?
    @NSManaged public var endTime: Date?
    @NSManaged public var createdAt: Date?
}

extension SessionEntity {
    static func fetchRequest() -> NSFetchRequest<SessionEntity> {
        return NSFetchRequest<SessionEntity>(entityName: "SessionEntity")
    }
}

// MARK: - PatternEntity

@objc(PatternEntity)
public class PatternEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var totalRows: Int32
    @NSManaged public var currentRow: Int32
    @NSManaged public var completedRows: String?
    @NSManaged public var projectId: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
}

extension PatternEntity {
    static func fetchRequest() -> NSFetchRequest<PatternEntity> {
        return NSFetchRequest<PatternEntity>(entityName: "PatternEntity")
    }

    static func fetchRequestForCount() -> NSFetchRequest<NSNumber> {
        let request = NSFetchRequest<NSNumber>(entityName: "PatternEntity")
        request.resultType = .countResultType
        return request
    }
}

// MARK: - SettingsEntity

@objc(SettingsEntity)
public class SettingsEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var key: String?
    @NSManaged public var value: String?
    @NSManaged public var updatedAt: Date?
}

extension SettingsEntity {
    static func fetchRequest() -> NSFetchRequest<SettingsEntity> {
        return NSFetchRequest<SettingsEntity>(entityName: "SettingsEntity")
    }
}
