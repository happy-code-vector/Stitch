import Foundation
import SwiftUI

class ProjectStore: ObservableObject {
    @Published var projects: [Project] = []
    @Published var activeProjectId: String?
    @Published var isLoading = false
    @Published var error: String?
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        projects = [
            Project(
                id: "1",
                userId: "user-1",
                name: "Winter Scarf",
                type: .scarf,
                progress: 68,
                totalRows: 120,
                completedRows: 82,
                lastWorked: "2h ago"
            ),
            Project(
                id: "2",
                userId: "user-1",
                name: "Beanie",
                type: .beanie,
                progress: 45,
                totalRows: 80,
                completedRows: 36,
                lastWorked: "1d ago"
            ),
            Project(
                id: "3",
                userId: "user-1",
                name: "Sweater",
                type: .sweater,
                progress: 23,
                totalRows: 200,
                completedRows: 46,
                lastWorked: "3d ago"
            ),
            Project(
                id: "4",
                userId: "user-1",
                name: "Mittens",
                type: .mittens,
                progress: 89,
                totalRows: 60,
                completedRows: 53,
                lastWorked: "5h ago"
            ),
            Project(
                id: "5",
                userId: "user-1",
                name: "Baby Blanket",
                type: .blanket,
                progress: 12,
                totalRows: 150,
                completedRows: 18,
                lastWorked: "1w ago"
            )
        ]
        activeProjectId = "1"
    }
    
    func addProject(_ project: Project) {
        projects.insert(project, at: 0)
    }
    
    func updateProject(_ id: String, updates: (inout Project) -> Void) {
        if let index = projects.firstIndex(where: { $0.id == id }) {
            updates(&projects[index])
            projects[index].updatedAt = Date()
        }
    }
    
    func deleteProject(_ id: String) {
        projects.removeAll { $0.id == id }
        if activeProjectId == id {
            activeProjectId = nil
        }
    }
    
    func setActiveProject(_ id: String?) {
        activeProjectId = id
    }
    
    func getActiveProject() -> Project? {
        guard let activeProjectId = activeProjectId else { return nil }
        return projects.first { $0.id == activeProjectId }
    }
    
    func getProject(by id: String) -> Project? {
        return projects.first { $0.id == id }
    }
}