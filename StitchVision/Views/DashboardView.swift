import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var projectStore = ProjectStore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Good morning!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            Text("Ready to knit?")
                                .font(.body)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            appState.navigateTo(.settings)
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Active Project Card
                    if let activeProject = projectStore.getActiveProject() {
                        ActiveProjectCardView(project: activeProject) {
                            appState.navigateTo(.workMode)
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Quick Actions
                    HStack(spacing: 16) {
                        QuickActionButton(
                            title: "New Project",
                            icon: "plus.circle.fill",
                            color: Color(red: 0.561, green: 0.659, blue: 0.533)
                        ) {
                            appState.navigateTo(.projectSetup)
                        }
                        
                        QuickActionButton(
                            title: "Upload Pattern",
                            icon: "camera.fill",
                            color: Color(red: 0.8, green: 0.6, blue: 0.8)
                        ) {
                            appState.navigateTo(.patternUpload)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Recent Projects
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent Projects")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(projectStore.projects.filter { $0.id != projectStore.activeProjectId }) { project in
                                ProjectRowView(project: project) {
                                    appState.selectedProjectId = project.id
                                    appState.navigateTo(.projectDetail)
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .background(Color(red: 0.976, green: 0.969, blue: 0.949))
            .ignoresSafeArea()
        }
        .environmentObject(projectStore)
    }
}

struct ActiveProjectCardView: View {
    let project: Project
    let onStartKnitting: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Last worked: \(project.lastWorked ?? "Never")")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(project.progress))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(project.completedRows)/\(project.totalRows) rows")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Progress bar
            ProgressView(value: project.progress / 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Button(action: onStartKnitting) {
                Text("Start Knitting")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(20)
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.561, green: 0.659, blue: 0.533),
                    Color(red: 0.461, green: 0.559, blue: 0.433)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProjectRowView: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Project type icon
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(project.type.displayName.prefix(1))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text("\(Int(project.progress))% complete • \(project.lastWorked ?? "Never")")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
}