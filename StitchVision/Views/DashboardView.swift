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
                // Header with gradient background
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(ThemeColors.primaryGradient)
                                .frame(width: 48, height: 48)
                                .shadow(color: ThemeColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                                .overlay(
                                    Text(appState.userName?.first?.uppercased() ?? "S")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Good \(timeOfDay),")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(ThemeColors.textSecondary)
                                Text(appState.userName ?? "Creator")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(ThemeColors.textPrimary)
                            }
                        }

                        Spacer()

                        Button(action: {
                            appState.navigateTo(.settings)
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(ThemeColors.primary)
                                .frame(width: 44, height: 44)
                                .background(ThemeColors.primaryLight)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                }
                .background(
                    ThemeColors.warmGradient
                )

                // Tip Banner when no active project
                if activeProject == nil {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(ThemeColors.warmGold)
                            .font(.system(size: 18, weight: .semibold))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Select or create a project to use Work Mode")
                                .font(.subheadline)
                                .foregroundColor(ThemeColors.textPrimary)
                            HStack(spacing: 8) {
                                Button(action: {
                                    appState.navigateTo(.projectSetup)
                                }) {
                                    Text("Create Project")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background(ThemeColors.primary)
                                        .cornerRadius(10)
                                }
                                if !projectStore.projects.isEmpty {
                                    Button(action: {
                                        showProjectPicker = true
                                    }) {
                                        Text("Select Active")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(ThemeColors.primary)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 7)
                                            .background(ThemeColors.primaryLight)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(ThemeColors.surface)
                    .cornerRadius(16)
                    .shadow(color: ThemeColors.primary.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }

                // Active Project Card
                if let project = activeProject {
                    ActiveProjectCardView(project: project, appState: appState)
                        .padding(.top, 20)
                } else {
                    NoActiveProjectCardView(appState: appState)
                        .padding(.top, 20)
                }

                // Quick Access Cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        QuickAccessCard(
                            icon: "number.circle.fill",
                            title: "Quick Count",
                            gradient: [
                                Color(red: 0.4, green: 0.6, blue: 0.8),
                                Color(red: 0.3, green: 0.5, blue: 0.7)
                            ]
                        ) {
                            appState.navigateTo(.workMode)
                        }

                        QuickAccessCard(
                            icon: "archivebox.circle.fill",
                            title: "Add to Stash",
                            gradient: [
                                Color(red: 0.949, green: 0.631, blue: 0.286),
                                Color(red: 0.85, green: 0.53, blue: 0.2)
                            ]
                        ) {
                            appState.navigateTo(.projectSetup)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 20)

                // Project Stash
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Your Project Stash")

                    if otherProjects.isEmpty {
                        Button(action: {
                            appState.navigateTo(.projectSetup)
                        }) {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(ThemeColors.primaryGradient)
                                        .frame(width: 48, height: 48)
                                    Image(systemName: "plus")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
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
                            .background(ThemeColors.surface)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
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
                .padding(.top, 28)

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
                .background(ThemeColors.surfaceWarm)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
                .padding(.horizontal, 24)
                .padding(.top, 24)

                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Quick Actions")

                    VStack(spacing: 12) {
                        QuickActionButton(
                            icon: "plus.circle.fill",
                            title: "New Project",
                            subtitle: "Start tracking a new project",
                            color: ThemeColors.primary
                        ) {
                            appState.navigateTo(.projectSetup)
                        }

                        QuickActionButton(
                            icon: "doc.text.fill",
                            title: "Upload Pattern",
                            subtitle: "Add a new pattern",
                            color: ThemeColors.accent
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
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(ThemeColors.primary)
                        .cornerRadius(14)
                        .shadow(color: ThemeColors.primary.opacity(0.4), radius: 12, x: 0, y: 6)
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

// MARK: - Section Header

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(ThemeColors.textPrimary)
            .padding(.horizontal, 24)
    }
}

// MARK: - Quick Access Card

struct QuickAccessCard: View {
    let icon: String
    let title: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)
            }
            .frame(width: 100, height: 90)
            .background(ThemeColors.surface)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
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
                RoundedRectangle(cornerRadius: 20)
                    .fill(ThemeColors.surface)
                    .shadow(color: ThemeColors.primary.opacity(0.12), radius: 12, x: 0, y: 6)

                VStack(spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(ThemeColors.primaryLight, lineWidth: 6)
                                .frame(width: 76, height: 76)

                            Circle()
                                .trim(from: 0, to: CGFloat(progress))
                                .stroke(
                                    ThemeColors.primaryGradient,
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                )
                                .frame(width: 76, height: 76)
                                .rotationEffect(.degrees(-90))

                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(ThemeColors.textPrimary)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(project.name)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
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
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14))
                            Text("Continue Working")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ThemeColors.primaryGradient)
                        .cornerRadius(14)
                        .shadow(color: ThemeColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(24)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - No Active Project Card

struct NoActiveProjectCardView: View {
    let appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(ThemeColors.surface)
                    .shadow(color: ThemeColors.primary.opacity(0.12), radius: 12, x: 0, y: 6)

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(ThemeColors.primaryLight)
                            .frame(width: 80, height: 80)
                        Image(systemName: "plus")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(ThemeColors.primary)
                    }

                    VStack(spacing: 8) {
                        Text("No Active Project")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
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
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 14))
                            Text("Create New Project")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ThemeColors.primaryGradient)
                        .cornerRadius(14)
                        .shadow(color: ThemeColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(32)
            }
        }
        .padding(.horizontal, 24)
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
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(ThemeColors.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(ThemeColors.textPrimary)
                        .lineLimit(1)

                    Text(project.totalRows > 0 ? "\(project.currentRow)/\(project.totalRows) rows" : "Set up your pattern to begin")
                        .font(.caption)
                        .foregroundColor(ThemeColors.textSecondary)
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(ThemeColors.primaryLight)
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(ThemeColors.primaryGradient)
                            .frame(width: geometry.size.width * CGFloat(progress), height: 6)
                    }
                }
                .frame(height: 6)
            }
            .padding(16)
            .frame(width: 160)
            .background(ThemeColors.surface)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color.opacity(0.12))
                        .frame(width: 52, height: 52)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 22))
                                .foregroundColor(color)
                        )
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
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
            .background(ThemeColors.surface)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
        .environmentObject(ProjectStore())
}
