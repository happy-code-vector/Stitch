import Foundation
import CoreData
import CloudKit

/// CoreDataManager handles CoreData persistence with iCloud sync via CloudKit
class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()

    private(set) var persistentContainer: NSPersistentCloudKitContainer
    private var migrationCompleted: Bool {
        UserDefaults.standard.bool(forKey: "CoreDataMigrationCompleted")
    }

    @Published var isSyncing: Bool = false
    @Published var lastSyncDate: Date?

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "StitchVision")

        // Configure CloudKit
        guard let description = persistentContainer.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve persistent store description")
        }

        // Enable CloudKit sync
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.com.stitchvision.app"
        )

        // Enable persistent history tracking
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        persistentContainer.loadPersistentStores { [weak self] description, error in
            if let error = error {
                print("CoreData failed to load: \(error.localizedDescription)")
                return
            }

            print("CoreData loaded successfully")

            // Run migration from SQLite if needed
            if self?.migrationCompleted == false {
                self?.migrateFromSQLite()
            }
        }

        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Migration from SQLite

    private func migrateFromSQLite() {
        let migrationQueue = DispatchQueue(label: "com.stitchvision.migration", qos: .utility)

        migrationQueue.async { [weak self] in
            guard let self = self else { return }

            print("Starting SQLite to CoreData migration...")

            let oldDB = DatabaseManager.shared

            // Migrate user profile
            if let user = oldDB.getUser() {
                self.migrateUser(user)
            }

            // Migrate projects
            let projects = oldDB.getAllProjects()
            for project in projects {
                self.migrateProject(project)
            }

            // Migrate sessions
            for project in projects {
                if let projectId = project.id {
                    let sessions = oldDB.getSessionsForProject(projectId: projectId)
                    for session in sessions {
                        self.migrateSession(session, projectId: projectId)
                    }
                }
            }

            // Migrate patterns
            let patterns = oldDB.getPatterns()
            for pattern in patterns {
                self.migratePattern(pattern)
            }

            // Mark migration complete
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: "CoreDataMigrationCompleted")
                print("Migration completed successfully")
            }
        }
    }

    private func migrateUser(_ user: UserProfile) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let entity = UserProfileEntity(context: context)
            entity.id = UUID()
            entity.name = user.name
            entity.email = user.email
            entity.craftType = user.craftType
            entity.skillLevel = user.skillLevel
            entity.struggles = user.struggles.joined(separator: ",")
            entity.habitFrequency = user.habitFrequency
            entity.goal = user.goal
            entity.isPro = user.isPro
            entity.hasCompletedOnboarding = user.hasCompletedOnboarding
            entity.createdAt = Date()
            entity.updatedAt = Date()

            do {
                try context.save()
                print("Migrated user: \(user.name)")
            } catch {
                print("Failed to migrate user: \(error)")
            }
        }
    }

    private func migrateProject(_ project: ProjectModel) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let entity = ProjectEntity(context: context)
            entity.id = project.id != nil ? UUID() : UUID()
            entity.name = project.name
            entity.craftType = project.craftType
            entity.needleSize = project.needleSize
            entity.yarnType = project.yarnType
            entity.yarnColor = project.yarnColor
            entity.patternName = project.patternName
            entity.totalRows = Int32(project.totalRows)
            entity.currentRow = Int32(project.currentRow)
            entity.status = project.status
            entity.createdAt = Date()
            entity.updatedAt = Date()

            do {
                try context.save()
                print("Migrated project: \(project.name)")
            } catch {
                print("Failed to migrate project: \(error)")
            }
        }
    }

    private func migrateSession(_ session: SessionModel, projectId: Int) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let entity = SessionEntity(context: context)
            entity.id = UUID()
            entity.projectId = UUID() // Will need to map to new project ID
            entity.rowsKnit = Int32(session.rowsKnit)
            entity.timeSpent = Int32(session.timeSpent)

            let dateFormatter = ISO8601DateFormatter()
            entity.startTime = dateFormatter.date(from: session.startTime) ?? Date()
            entity.endTime = dateFormatter.date(from: session.endTime) ?? Date()
            entity.createdAt = Date()

            do {
                try context.save()
                print("Migrated session with \(session.rowsKnit) rows")
            } catch {
                print("Failed to migrate session: \(error)")
            }
        }
    }

    private func migratePattern(_ pattern: KnittingPattern) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let entity = PatternEntity(context: context)
            entity.id = pattern.id
            entity.name = pattern.name
            entity.imageData = pattern.imageData
            entity.totalRows = Int32(pattern.totalRows)
            entity.currentRow = Int32(pattern.currentRow)

            if let completedRowsData = try? JSONEncoder().encode(pattern.completedRows),
               let completedRowsString = String(data: completedRowsData, encoding: .utf8) {
                entity.completedRows = completedRowsString
            }

            entity.projectId = pattern.projectId
            entity.createdAt = Date()
            entity.updatedAt = Date()

            do {
                try context.save()
                print("Migrated pattern: \(pattern.name)")
            } catch {
                print("Failed to migrate pattern: \(error)")
            }
        }
    }

    // MARK: - Sync Control

    func triggerSync() {
        isSyncing = true

        persistentContainer.viewContext.perform { [weak self] in
            do {
                try self?.persistentContainer.viewContext.save()
                DispatchQueue.main.async {
                    self?.lastSyncDate = Date()
                    self?.isSyncing = false
                    print("Sync triggered successfully")
                }
            } catch {
                DispatchQueue.main.async {
                    self?.isSyncing = false
                    print("Sync failed: \(error)")
                }
            }
        }
    }

    // MARK: - User Operations

    func saveUser(_ user: UserProfile) {
        viewContext.perform { [weak self] in
            let fetchRequest: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
            fetchRequest.fetchLimit = 1

            do {
                let results = try self?.viewContext.fetch(fetchRequest)
                let entity = results?.first ?? UserProfileEntity(context: self!.viewContext)

                if entity.id == nil {
                    entity.id = UUID()
                }
                entity.name = user.name
                entity.email = user.email
                entity.craftType = user.craftType
                entity.skillLevel = user.skillLevel
                entity.struggles = user.struggles.joined(separator: ",")
                entity.habitFrequency = user.habitFrequency
                entity.goal = user.goal
                entity.isPro = user.isPro
                entity.hasCompletedOnboarding = user.hasCompletedOnboarding
                entity.updatedAt = Date()

                try self?.viewContext.save()
            } catch {
                print("Failed to save user: \(error)")
            }
        }
    }

    func getUser() -> UserProfile? {
        let fetchRequest: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            guard let entity = try viewContext.fetch(fetchRequest).first else {
                return nil
            }

            return UserProfile(
                id: 1,
                name: entity.name ?? "",
                email: entity.email ?? "",
                craftType: entity.craftType ?? "",
                skillLevel: entity.skillLevel ?? "",
                struggles: entity.struggles?.split(separator: ",").map(String.init) ?? [],
                habitFrequency: entity.habitFrequency ?? "",
                goal: entity.goal ?? "",
                isPro: entity.isPro,
                hasCompletedOnboarding: entity.hasCompletedOnboarding
            )
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }

    // MARK: - Project Operations

    func saveProject(_ project: ProjectModel) -> UUID? {
        let entity = ProjectEntity(context: viewContext)
        entity.id = UUID()
        entity.name = project.name
        entity.craftType = project.craftType
        entity.needleSize = project.needleSize
        entity.yarnType = project.yarnType
        entity.yarnColor = project.yarnColor
        entity.patternName = project.patternName
        entity.totalRows = Int32(project.totalRows)
        entity.currentRow = Int32(project.currentRow)
        entity.status = project.status
        entity.createdAt = Date()
        entity.updatedAt = Date()

        do {
            try viewContext.save()
            return entity.id
        } catch {
            print("Failed to save project: \(error)")
            return nil
        }
    }

    func getAllProjects() -> [ProjectModel] {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]

        do {
            let entities = try viewContext.fetch(fetchRequest)
            return entities.map { entity in
                ProjectModel(
                    id: nil, // Map UUID to Int if needed, or update ProjectModel
                    name: entity.name ?? "",
                    craftType: entity.craftType ?? "",
                    needleSize: entity.needleSize ?? "",
                    yarnType: entity.yarnType ?? "",
                    yarnColor: entity.yarnColor ?? "",
                    patternName: entity.patternName ?? "",
                    totalRows: Int(entity.totalRows),
                    currentRow: Int(entity.currentRow),
                    status: entity.status ?? "active"
                )
            }
        } catch {
            print("Failed to fetch projects: \(error)")
            return []
        }
    }

    func updateProject(id: UUID, updates: (ProjectEntity) -> Void) -> Bool {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            guard let entity = try viewContext.fetch(fetchRequest).first else {
                return false
            }

            updates(entity)
            entity.updatedAt = Date()
            try viewContext.save()
            return true
        } catch {
            print("Failed to update project: \(error)")
            return false
        }
    }

    func deleteProject(id: UUID) -> Bool {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let entities = try viewContext.fetch(fetchRequest)
            for entity in entities {
                viewContext.delete(entity)
            }
            try viewContext.save()
            return true
        } catch {
            print("Failed to delete project: \(error)")
            return false
        }
    }

    // MARK: - Session Operations

    func saveSession(_ session: SessionModel, projectId: UUID) -> Bool {
        let entity = SessionEntity(context: viewContext)
        entity.id = UUID()
        entity.projectId = projectId
        entity.rowsKnit = Int32(session.rowsKnit)
        entity.timeSpent = Int32(session.timeSpent)

        let dateFormatter = ISO8601DateFormatter()
        entity.startTime = dateFormatter.date(from: session.startTime) ?? Date()
        entity.endTime = dateFormatter.date(from: session.endTime) ?? Date()
        entity.createdAt = Date()

        do {
            try viewContext.save()
            return true
        } catch {
            print("Failed to save session: \(error)")
            return false
        }
    }

    func getSessions(for projectId: UUID) -> [SessionEntity] {
        let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectId == %@", projectId as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch sessions: \(error)")
            return []
        }
    }

    func getAllSessions() -> [SessionEntity] {
        let fetchRequest: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch all sessions: \(error)")
            return []
        }
    }

    // MARK: - Pattern Operations

    func savePattern(_ pattern: KnittingPattern) -> Bool {
        let entity = PatternEntity(context: viewContext)
        entity.id = pattern.id
        entity.name = pattern.name
        entity.imageData = pattern.imageData
        entity.totalRows = Int32(pattern.totalRows)
        entity.currentRow = Int32(pattern.currentRow)

        if let completedRowsData = try? JSONEncoder().encode(pattern.completedRows),
           let completedRowsString = String(data: completedRowsData, encoding: .utf8) {
            entity.completedRows = completedRowsString
        }

        entity.projectId = pattern.projectId
        entity.createdAt = Date()
        entity.updatedAt = Date()

        do {
            try viewContext.save()
            return true
        } catch {
            print("Failed to save pattern: \(error)")
            return false
        }
    }

    func getPatterns() -> [KnittingPattern] {
        let fetchRequest: NSFetchRequest<PatternEntity> = PatternEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]

        do {
            return try viewContext.fetch(fetchRequest).map { entity in
                var completedRows: Set<Int> = []
                if let completedRowsString = entity.completedRows,
                   let data = completedRowsString.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode(Set<Int>.self, from: data) {
                    completedRows = decoded
                }

                return KnittingPattern(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    imageData: entity.imageData ?? Data(),
                    detectedRows: [],
                    totalRows: Int(entity.totalRows),
                    currentRow: Int(entity.currentRow),
                    completedRows: completedRows,
                    projectId: entity.projectId
                )
            }
        } catch {
            print("Failed to fetch patterns: \(error)")
            return []
        }
    }

    func deletePattern(id: UUID) -> Bool {
        let fetchRequest: NSFetchRequest<PatternEntity> = PatternEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let entities = try viewContext.fetch(fetchRequest)
            for entity in entities {
                viewContext.delete(entity)
            }
            try viewContext.save()
            return true
        } catch {
            print("Failed to delete pattern: \(error)")
            return false
        }
    }

    // MARK: - Pattern Count (for Free tier limits)

    func getPatternCount() -> Int {
        let fetchRequest: NSFetchRequest<NSNumber> = PatternEntity.fetchRequestForCount()
        do {
            return try viewContext.count(for: fetchRequest)
        } catch {
            print("Failed to count patterns: \(error)")
            return 0
        }
    }
}
