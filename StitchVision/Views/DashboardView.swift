import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    @State private var timeOfDay = "Morning"
    @State private var showSettingsMenu = false
    @State private var showProjectPicker = false
    @State private var showActiveToast = false
    @State private var activeToastText = ""
    
    var activeProject: ProjectModel? {
        projectStore.getActiveProject()
    }
    
    var otherProjects: [ProjectModel] {
        projectStore.projects.filter { $0.id != activeProject?.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        ThemeColors.primary,
                                        ThemeColors.primaryPressed
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 48, height: 48)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Good \(timeOfDay), \(appState.userName ?? "Creator")")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(ThemeColors.textPrimary)
                        }
                    }

                    Spacer()

                    Button(action: {
                        appState.navigateTo(.settings)
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title2)
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                    
                    // Tip Banner when no active project
                    if activeProject == nil {
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(ThemeColors.primary)
                                .font(.system(size: 16, weight: .semibold))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Select or create a project to use Work Mode")
                                    .font(.subheadline)
                                    .foregroundColor(ThemeColors.textPrimary)
                                Button(action: {
                                    appState.navigateTo(.projectSetup)
                                }) {
                                    Text("Create Project")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(ThemeColors.primary)
                                        .cornerRadius(12)
                                }
                                if !projectStore.projects.isEmpty {
                                    Button(action: {
                                        showProjectPicker = true
                                    }) {
                                        Text("Select Active")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(ThemeColors.primary)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                    }
                    
                    // Active Project Card
                    if let project = activeProject {
                        ActiveProjectCardView(project: project, appState: appState)
                    } else {
                        NoActiveProjectCardView(appState: appState)
                    }

                    // Quick Access Cards
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // Quick Count Card
                            Button(action: {
                                appState.navigateTo(.workMode)
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "number.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                    Text("Quick Count")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(ThemeColors.textPrimary)
                                }
                                .frame(width: 100, height: 80)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }

                            // Add to Stash Card
                            Button(action: {
                                appState.navigateTo(.projectSetup)
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "archivebox.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(Color(red: 0.949, green: 0.631, blue: 0.286))
                                    Text("Add to Stash")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(ThemeColors.textPrimary)
                                }
                                .frame(width: 100, height: 80)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Project Stash
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Project Stash")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(ThemeColors.textPrimary)
                            .padding(.horizontal, 24)

                        if otherProjects.isEmpty {
                            Button(action: {
                                appState.navigateTo(.projectSetup)
                            }) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(ThemeColors.primary.opacity(0.1))
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "plus")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(ThemeColors.primary)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Start your first project")
                                            .font(.headline)
                                            .foregroundColor(ThemeColors.textPrimary)
                                        Text("Tap here to create a project and start tracking")
                                            .font(.caption)
                                            .foregroundColor(ThemeColors.textSecondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(ThemeColors.textSecondary)
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal, 24)
                        } else {
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack(spacing: 16) {
                                    ForEach(otherProjects, id: \.id) { project in
                                        ProjectStashCard(project: project, appState: appState, projectStore: projectStore)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                    }
                    .padding(.top, 24)

                    // Engagement nudge
                    HStack(spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.949, green: 0.631, blue: 0.286))
                        Text("You've tracked 0 rows this week — let's change that")
                            .font(.subheadline)
                            .foregroundColor(ThemeColors.textSecondary)
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(ThemeColors.textPrimary)
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
                                subtitle: "Add a new pattern",
                                color: Color(red: 0.831, green: 0.502, blue: 0.435)
                            ) {
                                appState.navigateTo(.patternUpload)
                            }

                            QuickActionButton(
                                icon: "chart.bar.fill",
                                title: "View Analytics",
                                subtitle: "See your crafting statistics",
                                color: Color(red: 0.4, green: 0.6, blue: 0.8)
                            ) {
                                appState.navigateTo(.analytics)
                            }

                            QuickActionButton(
                                icon: "book.fill",
                                title: "Abbreviation Guide",
                                subtitle: "Look up knitting & crochet terms",
                                color: Color(red: 0.6, green: 0.4, blue: 0.8)
                            ) {
                                appState.navigateTo(.abbreviationGlossary)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 100)
            }
        }
        .background(ThemeColors.background.ignoresSafeArea())
        .overlay(
            Group {
                if showActiveToast {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text(activeToastText)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(16)
                        .padding(.bottom, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: showActiveToast)
                }
            }
        )
        .sheet(isPresented: $showProjectPicker) {
            NavigationView {
                List {
                    ForEach(projectStore.projects, id: \.id) { project in
                        Button(action: {
                            projectStore.setActiveProject(project.id)
                            activeToastText = "Active project set to \(project.name)"
                            showActiveToast = true
                            showProjectPicker = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeInOut) {
                                    showActiveToast = false
                                }
                            }
                        }) {
                            HStack {
                                Text(project.name)
                                Spacer()
                                if project.id == projectStore.activeProjectId {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(ThemeColors.primary)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Select Active Project")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") { showProjectPicker = false }
                    }
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
                                .foregroundColor(ThemeColors.textPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(project.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(ThemeColors.textPrimary)
                            
                            Text(project.totalRows > 0 ? "Row \(project.currentRow) of \(project.totalRows)" : "Set up your pattern to begin")
                                .font(.subheadline)
                                .foregroundColor(ThemeColors.textSecondary)
                            
                            if !project.yarnColor.isEmpty {
                                HStack(spacing: 4) {
                                    Text("🧶")
                                    Text(project.yarnColor)
                                        .font(.caption)
                                        .foregroundColor(ThemeColors.textSecondary)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        appState.selectedProjectId = project.id
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
                            .foregroundColor(ThemeColors.textPrimary)

                        Text("Start a new project to begin tracking your crafting progress")
                            .font(.subheadline)
                            .foregroundColor(ThemeColors.textSecondary)
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
                        .foregroundColor(ThemeColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(project.totalRows > 0 ? "\(project.currentRow)/\(project.totalRows) rows" : "Set up your pattern to begin")
                        .font(.caption)
                        .foregroundColor(ThemeColors.textSecondary)
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
                        .foregroundColor(ThemeColors.textPrimary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(ThemeColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ThemeColors.textSecondary)
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
