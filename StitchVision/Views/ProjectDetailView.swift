import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    @State private var showDeleteConfirm = false
    
    var project: ProjectModel? {
        guard let projectId = appState.selectedProjectId else { return nil }
        return projectStore.getProject(by: projectId)
    }
    
    var sessions: [SessionModel] {
        guard let projectId = appState.selectedProjectId else { return [] }
        return projectStore.getSessionsForProject(projectId: projectId)
    }
    
    var progress: Double {
        guard let project = project, project.totalRows > 0 else { return 0.0 }
        return Double(project.currentRow) / Double(project.totalRows)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            if let project = project {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            Button(action: {
                                appState.navigateTo(.dashboard)
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            }
                            
                            Spacer()
                            
                            Menu {
                                Button(action: {
                                    projectStore.setActiveProject(project.id)
                                    appState.navigateTo(.workMode)
                                }) {
                                    Label("Start Session", systemImage: "play.fill")
                                }
                                
                                Button(action: {
                                    showDeleteConfirm = true
                                }) {
                                    Label("Delete Project", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 48)
                        
                        // Project Info Card
                        VStack(spacing: 20) {
                            // Progress Ring
                            ZStack {
                                Circle()
                                    .stroke(Color(red: 0.898, green: 0.898, blue: 0.898), lineWidth: 12)
                                    .frame(width: 160, height: 160)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(progress))
                                    .stroke(
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack(spacing: 4) {
                                    Text("\(Int(progress * 100))%")
                                        .font(.system(size: 36, weight: .bold))
                                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    
                                    Text("Complete")
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                }
                            }
                            
                            // Project Name
                            Text(project.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            // Stats Grid
                            HStack(spacing: 24) {
                                StatItem(
                                    icon: "chart.line.uptrend.xyaxis",
                                    value: "\(project.currentRow)",
                                    label: "Current Row"
                                )
                                
                                Divider()
                                    .frame(height: 40)
                                
                                StatItem(
                                    icon: "flag.checkered",
                                    value: "\(project.totalRows)",
                                    label: "Total Rows"
                                )
                                
                                Divider()
                                    .frame(height: 40)
                                
                                StatItem(
                                    icon: "clock",
                                    value: "\(sessions.count)",
                                    label: "Sessions"
                                )
                            }
                            .padding(.vertical, 16)
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                        .padding(.horizontal, 24)
                        
                        // Project Details
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Project Details")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            VStack(spacing: 12) {
                                if !project.craftType.isEmpty {
                                    DetailRow(label: "Type", value: project.craftType)
                                }
                                
                                if !project.needleSize.isEmpty {
                                    DetailRow(label: "Needle Size", value: project.needleSize)
                                }
                                
                                if !project.yarnType.isEmpty {
                                    DetailRow(label: "Yarn", value: project.yarnType)
                                }
                                
                                if !project.yarnColor.isEmpty {
                                    DetailRow(label: "Color", value: project.yarnColor)
                                }
                                
                                if !project.patternName.isEmpty {
                                    DetailRow(label: "Pattern", value: project.patternName)
                                }
                                
                                DetailRow(label: "Status", value: project.status.capitalized)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 24)
                        
                        // Session History
                        if !sessions.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Session History")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                
                                VStack(spacing: 12) {
                                    ForEach(sessions.prefix(10), id: \.id) { session in
                                        SessionHistoryRow(session: session)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Action Button
                        Button(action: {
                            projectStore.setActiveProject(project.id)
                            appState.navigateTo(.workMode)
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start New Session")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    
                    Text("Project Not Found")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button("Go Back") {
                        appState.navigateTo(.dashboard)
                    }
                    .padding()
                }
            }
        }
        .alert("Delete Project", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let projectId = appState.selectedProjectId {
                    projectStore.deleteProject(projectId)
                    appState.navigateTo(.dashboard)
                }
            }
        } message: {
            Text("Are you sure you want to delete this project? This action cannot be undone.")
        }
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            Text(label)
                .font(.caption)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
        }
    }
}

struct SessionHistoryRow: View {
    let session: SessionModel
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if let date = ISO8601DateFormatter().date(from: session.startTime) {
            return formatter.string(from: date)
        }
        return session.startTime
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text("\(session.rowsKnit) rows • \(session.timeSpent / 60) min")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ProjectDetailView()
        .environmentObject(AppState())
        .environmentObject(ProjectStore())
}
