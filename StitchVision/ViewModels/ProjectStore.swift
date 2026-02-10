import Foundation
import SwiftUI

class ProjectStore: ObservableObject {
    @Published var projects: [ProjectModel] = []
    @Published var activeProjectId: Int?
    @Published var isLoading = false
    @Published var error: String?
    
    private let db = DatabaseManager.shared
    
    init() {
        loadProjects()
    }
    
    func loadProjects() {
        isLoading = true
        projects = db.getAllProjects()
        isLoading = false
        
        // Set first project as active if none selected
        if activeProjectId == nil && !projects.isEmpty {
            activeProjectId = projects.first?.id
        }
    }
    
    func addProject(_ project: ProjectModel) {
        if let projectId = db.saveProject(project) {
            var savedProject = project
            savedProject.id = projectId
            projects.insert(savedProject, at: 0)
            activeProjectId = projectId
        }
    }
    
    func updateProject(_ project: ProjectModel) {
        if db.updateProject(project) {
            if let index = projects.firstIndex(where: { $0.id == project.id }) {
                projects[index] = project
            }
        }
    }
    
    func deleteProject(_ id: Int) {
        if db.deleteProject(id: id) {
            projects.removeAll { $0.id == id }
            if activeProjectId == id {
                activeProjectId = projects.first?.id
            }
        }
    }
    
    func setActiveProject(_ id: Int?) {
        activeProjectId = id
    }
    
    func getActiveProject() -> ProjectModel? {
        guard let activeProjectId = activeProjectId else { return nil }
        return projects.first { $0.id == activeProjectId }
    }
    
    func getProject(by id: Int) -> ProjectModel? {
        return projects.first { $0.id == id }
    }
    
    func updateProjectProgress(projectId: Int, currentRow: Int) {
        if var project = getProject(by: projectId) {
            project.currentRow = currentRow
            updateProject(project)
        }
    }
    
    func saveSession(projectId: Int, rowsKnit: Int, timeSpent: Int) {
        let dateFormatter = ISO8601DateFormatter()
        let now = dateFormatter.string(from: Date())
        
        let session = SessionModel(
            projectId: projectId,
            rowsKnit: rowsKnit,
            timeSpent: timeSpent,
            startTime: now,
            endTime: now
        )
        
        _ = db.saveSession(session)
        
        // Update project progress
        updateProjectProgress(projectId: projectId, currentRow: (getProject(by: projectId)?.currentRow ?? 0) + rowsKnit)
    }
    
    func getSessionsForProject(projectId: Int) -> [SessionModel] {
        return db.getSessionsForProject(projectId: projectId)
    }
}