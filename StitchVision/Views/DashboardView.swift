import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @State private var timeOfDay = "Morning"
    @State private var showSettingsMenu = false
    @State private var leftHandedMode = false
    
    // Sample data - in real app this would come from data store
    let activeProject = ActiveProject(
        title: "Winter Scarf",
        lastWorked: "2h ago",
        progress: 68,
        totalRows: 120,
        completedRows: 82
    )
    
    let stashProjects = [
        StashProject(id: 1, name: "Beanie", type: "beanie", progress: 45),
        StashProject(id: 2, name: "Sweater", type: "sweater", progress: 23),
        StashProject(id: 3, name: "Mittens", type: "mittens", progress: 89),
        StashProject(id: 4, name: "Baby Blanket", type: "blanket", progress: 12)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        HStack(spacing: 16) {
                            // Avatar
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
                                Text("Good \(timeOfDay), Creator")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            }
                        }
                        
                        Spacer()
                        
                        // Settings Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showSettingsMenu.toggle()
                            }
                        }) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        }
                        .scaleEffect(showSettingsMenu ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showSettingsMenu)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 48)
                    .padding(.bottom, 24)
                    
                    // Hero Section - Continue Working Card
                    VStack(spacing: 0) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                            
                            VStack(spacing: 0) {
                                HStack(alignment: .top, spacing: 16) {
                                    // Progress Ring
                                    ZStack {
                                        Circle()
                                            .stroke(Color(red: 0.898, green: 0.898, blue: 0.898), lineWidth: 6)
                                            .frame(width: 80, height: 80)
                                        
                                        Circle()
                                            .trim(from: 0, to: CGFloat(activeProject.progress) / 100)
                                            .stroke(
                                                Color(red: 0.561, green: 0.659, blue: 0.533),
                                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                            )
                                            .frame(width: 80, height: 80)
                                            .rotationEffect(.degrees(-90))
                                            .animation(.easeOut(duration: 1).delay(0.4), value: activeProject.progress)
                                        
                                        Text("\(activeProject.progress)%")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                            .opacity(1.0)
                                            .animation(.easeOut(duration: 0.6).delay(0.6), value: activeProject.progress)
                                    }
                                    
                                    // Project Info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Continue Working")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                        
                                        Text(activeProject.title)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Text("Last worked \(activeProject.lastWorked)")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                            .padding(.bottom, 12)
                                        
                                        Text("Row \(activeProject.completedRows) of \(activeProject.totalRows)")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 24)
                                
                                // Resume Button
                                Button(action: {
                                    appState.navigateTo(.workMode)
                                }) {
                                    Text("Resume")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                        .cornerRadius(25)
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 24)
                                .padding(.bottom, 24)
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: activeProject.progress)
                            }
                        }
                        
                        // Mascot sitting on card
                        HStack {
                            Spacer()
                            AnimatedMascotView()
                                .offset(y: -32)
                            Spacer().frame(width: 24)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // My Stash Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("My Stash")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        // 2-Column Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 8),
                            GridItem(.flexible(), spacing: 8)
                        ], spacing: 16) {
                            ForEach(Array(stashProjects.enumerated()), id: \.element.id) { index, project in
                                ProjectCardView(project: project, index: index) {
                                    // Handle project tap
                                    appState.selectedProjectId = project.id
                                    appState.navigateTo(.projectDetail)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 100) // Space for FAB
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        appState.navigateTo(.projectSetup)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showSettingsMenu)
                    .padding(.trailing, 24)
                    .padding(.bottom, 32)
                }
            }
            
            // Settings Dropdown Menu
            if showSettingsMenu {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showSettingsMenu = false
                        }
                    }
                
                VStack {
                    HStack {
                        Spacer()
                        SettingsMenuView(
                            leftHandedMode: $leftHandedMode,
                            onRestorePurchases: {
                                // Handle restore purchases
                                showSettingsMenu = false
                            },
                            onAllSettings: {
                                showSettingsMenu = false
                                appState.navigateTo(.settings)
                            },
                            onDeleteAccount: {
                                // Handle delete account
                                showSettingsMenu = false
                            }
                        )
                        .padding(.trailing, 24)
                    }
                    .padding(.top, 80)
                    Spacer()
                }
            }
        }
        .onAppear {
            updateTimeOfDay()
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

// MARK: - Supporting Views

struct ProjectCardView: View {
    let project: StashProject
    let index: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Project Icon
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.2),
                                Color(red: 0.49, green: 0.57, blue: 0.46).opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(project.emoji)
                            .font(.title2)
                    )
                
                // Project Name
                Text(project.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.leading)
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 4) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.898, green: 0.898, blue: 0.898))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .frame(width: geometry.size.width * CGFloat(project.progress) / 100, height: 6)
                                .animation(.easeOut(duration: 0.8).delay(0.5 + Double(index) * 0.1), value: project.progress)
                        }
                    }
                    .frame(height: 6)
                    
                    Text("\(project.progress)%")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: project.progress)
    }
}

struct AnimatedMascotView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Yarn Ball Body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.49, green: 0.57, blue: 0.46)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
            
            // Yarn Texture Lines
            VStack(spacing: 4) {
                Path { path in
                    path.move(to: CGPoint(x: 15, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 45, y: 0), control: CGPoint(x: 30, y: -2))
                }
                .stroke(Color(red: 0.62, green: 0.71, blue: 0.59), lineWidth: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 15, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 45, y: 0), control: CGPoint(x: 30, y: 2))
                }
                .stroke(Color(red: 0.62, green: 0.71, blue: 0.59), lineWidth: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 15, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 45, y: 0), control: CGPoint(x: 30, y: -2))
                }
                .stroke(Color(red: 0.62, green: 0.71, blue: 0.59), lineWidth: 1)
            }
            
            // Highlight
            Ellipse()
                .fill(.white.opacity(0.4))
                .frame(width: 24, height: 16)
                .offset(x: -8, y: -8)
            
            // Happy Eyes
            HStack(spacing: 10) {
                Circle()
                    .fill(.black)
                    .frame(width: 5, height: 5)
                Circle()
                    .fill(.black)
                    .frame(width: 5, height: 5)
            }
            .offset(y: -6)
            
            // Smile - closer to eyes
            Path { path in
                path.move(to: CGPoint(x: -8, y: 2))
                path.addQuadCurve(to: CGPoint(x: 8, y: 2), control: CGPoint(x: 0, y: 7))
            }
            .stroke(.black, lineWidth: 2)
            .fill(.clear)
            
            // Rosy Cheeks - closer to face
            HStack(spacing: 20) {
                Ellipse()
                    .fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6))
                    .frame(width: 8, height: 5)
                Ellipse()
                    .fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6))
                    .frame(width: 8, height: 5)
            }
            .offset(y: 0)
            
            // Waving Arm
            Path { path in
                path.move(to: CGPoint(x: -30, y: 0))
                path.addQuadCurve(to: CGPoint(x: -42, y: -12), control: CGPoint(x: -38, y: -8))
            }
            .stroke(Color(red: 0.49, green: 0.57, blue: 0.46), lineWidth: 4)
            .overlay(
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(width: 6, height: 6)
                    .offset(x: -42, y: -12)
            )
            .rotationEffect(.degrees(isAnimating ? -15 : 0))
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
        }
        .offset(y: isAnimating ? -5 : 0)
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct SettingsMenuView: View {
    @Binding var leftHandedMode: Bool
    let onRestorePurchases: () -> Void
    let onAllSettings: () -> Void
    let onDeleteAccount: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Restore Purchases
            Button(action: onRestorePurchases) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Restore Purchases")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    Text("Recover your subscription")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            
            Divider()
                .background(Color(red: 0.867, green: 0.867, blue: 0.867))
            
            // Left-Handed Mode
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Left-Handed Mode")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    Text("Mirrors the video feed")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                Spacer()
                
                // Toggle Switch
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        leftHandedMode.toggle()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(leftHandedMode ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.867, green: 0.867, blue: 0.867))
                            .frame(width: 48, height: 28)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 24, height: 24)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .offset(x: leftHandedMode ? 10 : -10)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: leftHandedMode)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            
            Divider()
                .background(Color(red: 0.867, green: 0.867, blue: 0.867))
            
            // All Settings
            Button(action: onAllSettings) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("All Settings")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    Text("Preferences & account")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            
            Divider()
                .background(Color(red: 0.867, green: 0.867, blue: 0.867))
            
            // Delete Account
            Button(action: onDeleteAccount) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Delete Account")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.79, green: 0.43, blue: 0.37))
                    Text("Permanently remove your data")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
        .frame(width: 280)
        .scaleEffect(showSettingsMenu ? 1.0 : 0.95)
        .opacity(showSettingsMenu ? 1.0 : 0.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showSettingsMenu)
    }
    
    @State private var showSettingsMenu = true
}

// MARK: - Data Models

struct ActiveProject {
    let title: String
    let lastWorked: String
    let progress: Int
    let totalRows: Int
    let completedRows: Int
}

struct StashProject {
    let id: Int
    let name: String
    let type: String
    let progress: Int
    
    var emoji: String {
        switch type {
        case "beanie": return "🧢"
        case "sweater": return "🧶"
        case "mittens": return "🧤"
        case "blanket": return "🛏️"
        default: return "🧶"
        }
    }
}