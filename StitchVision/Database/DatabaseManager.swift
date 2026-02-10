import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: OpaquePointer?
    private let dbPath: String
    
    private init() {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        dbPath = documentsPath.appendingPathComponent("stitchvision.sqlite").path
        
        openDatabase()
        createTables()
    }
    
    // MARK: - Database Connection
    
    private func openDatabase() {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        print("Successfully opened database at: \(dbPath)")
    }
    
    func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        db = nil
    }
    
    // MARK: - Create Tables
    
    private func createTables() {
        createUserTable()
        createProjectsTable()
        createSessionsTable()
        createSettingsTable()
    }
    
    private func createUserTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS User (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            craft_type TEXT,
            skill_level TEXT,
            struggles TEXT,
            habit_frequency TEXT,
            goal TEXT,
            is_pro INTEGER DEFAULT 0,
            has_completed_onboarding INTEGER DEFAULT 0,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        );
        """
        
        executeQuery(createTableQuery)
    }
    
    private func createProjectsTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Projects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            name TEXT NOT NULL,
            craft_type TEXT,
            needle_size TEXT,
            yarn_type TEXT,
            yarn_color TEXT,
            pattern_name TEXT,
            total_rows INTEGER DEFAULT 0,
            current_row INTEGER DEFAULT 0,
            status TEXT DEFAULT 'active',
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES User(id)
        );
        """
        
        executeQuery(createTableQuery)
    }
    
    private func createSessionsTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            project_id INTEGER,
            rows_knit INTEGER DEFAULT 0,
            time_spent INTEGER DEFAULT 0,
            start_time TEXT,
            end_time TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (project_id) REFERENCES Projects(id)
        );
        """
        
        executeQuery(createTableQuery)
    }
    
    private func createSettingsTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT UNIQUE NOT NULL,
            value TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        );
        """
        
        executeQuery(createTableQuery)
    }
    
    // MARK: - Execute Query
    
    @discardableResult
    private func executeQuery(_ query: String) -> Bool {
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing query: \(errorMessage)")
            return false
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error executing query: \(errorMessage)")
            sqlite3_finalize(statement)
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
    
    // MARK: - User Operations
    
    func saveUser(_ user: UserProfile) -> Bool {
        let query = """
        INSERT OR REPLACE INTO User (id, name, email, craft_type, skill_level, struggles, habit_frequency, goal, is_pro, has_completed_onboarding, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, datetime('now'));
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing user insert")
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(user.id ?? 1))
        sqlite3_bind_text(statement, 2, (user.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (user.email as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, (user.craftType as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 5, (user.skillLevel as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 6, (user.struggles.joined(separator: ",") as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 7, (user.habitFrequency as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 8, (user.goal as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 9, user.isPro ? 1 : 0)
        sqlite3_bind_int(statement, 10, user.hasCompletedOnboarding ? 1 : 0)
        
        let success = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        return success
    }
    
    func getUser() -> UserProfile? {
        let query = "SELECT * FROM User ORDER BY id DESC LIMIT 1;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            print("Error preparing user select")
            return nil
        }
        
        var user: UserProfile?
        
        if sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 1))
            let email = String(cString: sqlite3_column_text(statement, 2))
            let craftType = String(cString: sqlite3_column_text(statement, 3))
            let skillLevel = String(cString: sqlite3_column_text(statement, 4))
            let strugglesString = String(cString: sqlite3_column_text(statement, 5))
            let struggles = strugglesString.split(separator: ",").map(String.init)
            let habitFrequency = String(cString: sqlite3_column_text(statement, 6))
            let goal = String(cString: sqlite3_column_text(statement, 7))
            let isPro = sqlite3_column_int(statement, 8) == 1
            let hasCompletedOnboarding = sqlite3_column_int(statement, 9) == 1
            
            user = UserProfile(
                id: id,
                name: name,
                email: email,
                craftType: craftType,
                skillLevel: skillLevel,
                struggles: struggles,
                habitFrequency: habitFrequency,
                goal: goal,
                isPro: isPro,
                hasCompletedOnboarding: hasCompletedOnboarding
            )
        }
        
        sqlite3_finalize(statement)
        return user
    }
    
    func updateOnboardingStatus(completed: Bool) -> Bool {
        let query = "UPDATE User SET has_completed_onboarding = ?, updated_at = datetime('now') WHERE id = 1;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        
        sqlite3_bind_int(statement, 1, completed ? 1 : 0)
        let success = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        return success
    }
    
    // MARK: - Project Operations
    
    func saveProject(_ project: ProjectModel) -> Int? {
        let query = """
        INSERT INTO Projects (user_id, name, craft_type, needle_size, yarn_type, yarn_color, pattern_name, total_rows, current_row, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return nil
        }
        
        sqlite3_bind_int(statement, 1, 1) // user_id
        sqlite3_bind_text(statement, 2, (project.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (project.craftType as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, (project.needleSize as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 5, (project.yarnType as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 6, (project.yarnColor as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 7, (project.patternName as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 8, Int32(project.totalRows))
        sqlite3_bind_int(statement, 9, Int32(project.currentRow))
        sqlite3_bind_text(statement, 10, (project.status as NSString).utf8String, -1, nil)
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            sqlite3_finalize(statement)
            return nil
        }
        
        let projectId = Int(sqlite3_last_insert_rowid(db))
        sqlite3_finalize(statement)
        
        return projectId
    }
    
    func getAllProjects() -> [ProjectModel] {
        let query = "SELECT * FROM Projects ORDER BY updated_at DESC;"
        var statement: OpaquePointer?
        var projects: [ProjectModel] = []
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return projects
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let name = String(cString: sqlite3_column_text(statement, 2))
            let craftType = String(cString: sqlite3_column_text(statement, 3))
            let needleSize = String(cString: sqlite3_column_text(statement, 4))
            let yarnType = String(cString: sqlite3_column_text(statement, 5))
            let yarnColor = String(cString: sqlite3_column_text(statement, 6))
            let patternName = String(cString: sqlite3_column_text(statement, 7))
            let totalRows = Int(sqlite3_column_int(statement, 8))
            let currentRow = Int(sqlite3_column_int(statement, 9))
            let status = String(cString: sqlite3_column_text(statement, 10))
            
            let project = ProjectModel(
                id: id,
                name: name,
                craftType: craftType,
                needleSize: needleSize,
                yarnType: yarnType,
                yarnColor: yarnColor,
                patternName: patternName,
                totalRows: totalRows,
                currentRow: currentRow,
                status: status
            )
            
            projects.append(project)
        }
        
        sqlite3_finalize(statement)
        return projects
    }
    
    func updateProject(_ project: ProjectModel) -> Bool {
        let query = """
        UPDATE Projects SET name = ?, craft_type = ?, needle_size = ?, yarn_type = ?, yarn_color = ?, 
        pattern_name = ?, total_rows = ?, current_row = ?, status = ?, updated_at = datetime('now')
        WHERE id = ?;
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        
        sqlite3_bind_text(statement, 1, (project.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (project.craftType as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 3, (project.needleSize as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 4, (project.yarnType as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 5, (project.yarnColor as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 6, (project.patternName as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 7, Int32(project.totalRows))
        sqlite3_bind_int(statement, 8, Int32(project.currentRow))
        sqlite3_bind_text(statement, 9, (project.status as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 10, Int32(project.id ?? 0))
        
        let success = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        return success
    }
    
    func deleteProject(id: Int) -> Bool {
        let query = "DELETE FROM Projects WHERE id = ?;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(id))
        let success = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        return success
    }
    
    // MARK: - Session Operations
    
    func saveSession(_ session: SessionModel) -> Bool {
        let query = """
        INSERT INTO Sessions (project_id, rows_knit, time_spent, start_time, end_time)
        VALUES (?, ?, ?, ?, ?);
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(session.projectId ?? 0))
        sqlite3_bind_int(statement, 2, Int32(session.rowsKnit))
        sqlite3_bind_int(statement, 3, Int32(session.timeSpent))
        sqlite3_bind_text(statement, 4, (session.startTime as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 5, (session.endTime as NSString).utf8String, -1, nil)
        
        let success = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        return success
    }
    
    func getSessionsForProject(projectId: Int) -> [SessionModel] {
        let query = "SELECT * FROM Sessions WHERE project_id = ? ORDER BY created_at DESC;"
        var statement: OpaquePointer?
        var sessions: [SessionModel] = []
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return sessions
        }
        
        sqlite3_bind_int(statement, 1, Int32(projectId))
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let projectId = Int(sqlite3_column_int(statement, 1))
            let rowsKnit = Int(sqlite3_column_int(statement, 2))
            let timeSpent = Int(sqlite3_column_int(statement, 3))
            let startTime = String(cString: sqlite3_column_text(statement, 4))
            let endTime = String(cString: sqlite3_column_text(statement, 5))
            
            let session = SessionModel(
                id: id,
                projectId: projectId,
                rowsKnit: rowsKnit,
                timeSpent: timeSpent,
                startTime: startTime,
                endTime: endTime
            )
            
            sessions.append(session)
        }
        
        sqlite3_finalize(statement)
        return sessions
    }
    
    // MARK: - Settings Operations
    
    func saveSetting(key: String, value: String) -> Bool {
        let query = """
        INSERT OR REPLACE INTO Settings (key, value, updated_at)
        VALUES (?, ?, datetime('now'));
        """
        
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        
        sqlite3_bind_text(statement, 1, (key as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (value as NSString).utf8String, -1, nil)
        
        let success = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)
        
        return success
    }
    
    func getSetting(key: String) -> String? {
        let query = "SELECT value FROM Settings WHERE key = ?;"
        var statement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return nil
        }
        
        sqlite3_bind_text(statement, 1, (key as NSString).utf8String, -1, nil)
        
        var value: String?
        if sqlite3_step(statement) == SQLITE_ROW {
            value = String(cString: sqlite3_column_text(statement, 0))
        }
        
        sqlite3_finalize(statement)
        return value
    }
}
