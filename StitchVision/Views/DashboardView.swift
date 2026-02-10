import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    @State private var timeOfDay = "Morning"
    @State private var showSettingsMenu = false
    
    var activeProject: ProjectModel? {
        projectStore.getActiveProject()
    }
    
    var otherProjects: [ProjectModel] {
        projectStore.projects.filter { $0.id != activeProject?.id }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.561, green: 0.659, blue: 0.533),
                                            Color(red: 0.49, green: 0.57, blue: 0.46)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text("👋")
                                        .font(.title2)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Good \(timeOfDay), \(appState.userName ?? "Creator")")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            appState.navigateTo(.settings)
                        }) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 48)
                    .padding(.bottom, 24)
                    
                    // Active Project Card
                    if let project = activeProject {
                        ActiveProjectCardView(project: project, appState: appState)
                    } else {
                        NoActiveProjectCardView(appState: appState)
                    }
                    
                    // Project Stash
                    if !otherProjects.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Project Stash")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(otherProjects, id: \.id) { project in
                                        ProjectStashCard(project: project, appState: appState, projectStore: projectStore)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 24)
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            QuickActionButton(
                                icon: "plus.circle.fill",
                                title: "New Project",
                                subtitle: "Start tracking a new project",
                                color: Color(red: 0.561, green: 0.659, blue: 0.533)
                            ) {
                                appState.navigateTo(.projectSetup)
                            }
                            
                            QuickActionButton(
                                icon: "doc.text.fill",
                                title: "Upload Pattern",
                                subtitle: "Add a new knitting pattern",
                                color: Color(red: 0.831, green: 0.502, blue: 0.435)
                            ) {
                                appState.navigateTo(.patternUpload)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            updateTimeOfDay()
            projectStore.loadProjects()
        }
    }
    
    private func updateTimeOfDay() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            timeOfDay = "Morning"
        } else if hour < 18 {
            timeOfDay = "Afternoon"
        } else {
            timeOfDay = "Evening"
        }
    }
}

// MARK: - Active Project Card

struct ActiveProjectCardView: View {
    let project: ProjectModel
    let appState: AppState
    
    var progress: Double {
        project.totalRows > 0 ? Double(project.currentRow) / Double(project.totalRows) : 0.0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                
                VStack(spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(Color(red: 0.898, green: 0.898, blue: 0.898), lineWidth: 6)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(progress))
                                .stroke(
                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                )
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(project.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            Text("Row \(project.currentRow) of \(project.totalRows)")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            
                            if !project.yarnColor.isEmpty {
                                HStack(spacing: 4) {
                                    Text("🧶")
                                    Text(project.yarnColor)
                                        .font(.caption)
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        appState.navigateTo(.workMode)
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Continue Working")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(24)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

// MARK: - No Active Project Card

struct NoActiveProjectCardView: View {
    let appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                
                VStack(spacing: 20) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    
                    VStack(spacing: 8) {
                        Text("No Active Project")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        Text("Start a new project to begin tracking your knitting progress")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    
                    Button(action: {
                        appState.navigateTo(.projectSetup)
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Project")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(32)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

// MARK: - Project Stash Card

struct ProjectStashCard: View {
    let project: ProjectModel
    let appState: AppState
    let projectStore: ProjectStore
    
    var progress: Double {
        project.totalRows > 0 ? Double(project.currentRow) / Double(project.totalRows) : 0.0
    }
    
    var body: some View {
        Button(action: {
            projectStore.setActiveProject(project.id)
            appState.selectedProjectId = project.id
            appState.navigateTo(.projectDetail)
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(projectEmoji)
                        .font(.system(size: 32))
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .lineLimit(1)
                    
                    Text("\(project.currentRow)/\(project.totalRows) rows")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.898, green: 0.898, blue: 0.898))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: geometry.size.width * CGFloat(progress), height: 6)
                    }
                }
                .frame(height: 6)
            }
            .padding(16)
            .frame(width: 160)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    var projectEmoji: String {
        let type = project.craftType.lowercased()
        if type.contains("scarf") { return "🧣" }
        if type.contains("beanie") || type.contains("hat") { return "🧢" }
        if type.contains("sweater") { return "🧥" }
        if type.contains("mitten") || type.contains("glove") { return "🧤" }
        if type.contains("blanket") { return "🛏️" }
        if type.contains("sock") { return "🧦" }
        return "🧶"
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(color)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
        .environmentObject(ProjectStore())
}
