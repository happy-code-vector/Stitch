import SwiftUI

struct SessionSummaryView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    let rowsKnit: Int
    let timeSpent: Int // in seconds
    let sessionStartTime: Date?
    
    // Convert seconds to minutes for display
    private var timeSpentMinutes: Int {
        max(1, Int(ceil(Double(timeSpent) / 60.0)))
    }

    // Calculate time saved (assuming 30 seconds per row without AI)
    private var timeWithoutAI: Int {
        Int(Double(rowsKnit) * 0.5) // minutes
    }

    private var timeSaved: Int {
        max(0, timeWithoutAI - timeSpentMinutes)
    }
    
    // Sparkle positions for background
    private let sparkles = [
        SparkleData(x: 0.1, y: 0.15, delay: 0),
        SparkleData(x: 0.85, y: 0.2, delay: 0.2),
        SparkleData(x: 0.15, y: 0.75, delay: 0.4),
        SparkleData(x: 0.9, y: 0.7, delay: 0.6),
        SparkleData(x: 0.5, y: 0.1, delay: 0.3),
        SparkleData(x: 0.75, y: 0.85, delay: 0.5),
    ]
    
    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()
            
            // Background Sparkles
            GeometryReader { geo in
                ForEach(Array(sparkles.enumerated()), id: \.offset) { index, sparkle in
                    SessionSparkleView(delay: sparkle.delay)
                        .position(
                            x: geo.size.width * sparkle.x,
                            y: geo.size.height * sparkle.y
                        )
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Main Victory Card
                VStack(spacing: 0) {
                    VStack(spacing: 24) {
                        // Big Bold Row Count
                        VStack(spacing: 8) {
                            Text("+\(rowsKnit) Rows")
                                .font(.system(size: 60, weight: .bold, design: .rounded))
                                .foregroundColor(ThemeColors.textPrimary)

                            Text("Progress made this session")
                                .font(.body)
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                        .padding(.top, 24)
                        
                        // Bar Chart Comparison
                        VStack(spacing: 16) {
                            Text("Time Comparison")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(ThemeColors.textSecondary)
                            
                            HStack(alignment: .bottom, spacing: 32) {
                                // Manual Count Bar (Taller, Gray)
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.gray.opacity(0.4),
                                                    Color.gray.opacity(0.3)
                                                ],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .frame(width: 80, height: timeWithoutAI > 0 ? 140 : 100)
                                        .animation(.easeOut(duration: 0.8).delay(0.9), value: timeWithoutAI)
                                    
                                    VStack(spacing: 2) {
                                        Text("Manual")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(ThemeColors.textSecondary)
                                        Text("\(timeWithoutAI)m")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(ThemeColors.textPrimary)
                                    }
                                }
                                
                                // StitchVision Bar (Shorter, Green)
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    ThemeColors.primary,
                                                    Color(red: 0.66, green: 0.76, blue: 0.63)
                                                ],
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .frame(width: 80, height: max(60, CGFloat(timeSpentMinutes) / CGFloat(max(timeWithoutAI, 1)) * 140))
                                        .animation(.easeOut(duration: 0.8).delay(1), value: timeSpentMinutes)
                                    
                                    VStack(spacing: 2) {
                                        Text("StitchVision")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(ThemeColors.textSecondary)
                                        Text("\(timeSpentMinutes)m")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(ThemeColors.primary)
                                    }
                                }
                            }
                            .frame(height: 180)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                    .background(ThemeColors.surface)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                    .overlay(
                        // Tilted "Time Saved" Sticker Badge
                        VStack(spacing: 2) {
                            Text("Time Saved")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                                .opacity(0.9)
                            Text("\(timeSaved) Mins")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.79, green: 0.43, blue: 0.37),
                                    Color(red: 0.72, green: 0.36, blue: 0.30)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .rotationEffect(.degrees(12))
                        .offset(x: 120, y: -120)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.6), value: timeSaved)
                    )
                }
                .padding(.horizontal, 24)
                
                // Action Buttons
                VStack(spacing: 16) {
                    // Primary: Save Progress
                    Button(action: saveSession) {
                        Text("Save Progress")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ThemeColors.primary)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rowsKnit)
                    
                    // Secondary: Discard Session
                    Button(action: {
                        appState.navigateTo(.dashboard)
                    }) {
                        Text("Discard Session")
                            .font(.body)
                            .foregroundColor(ThemeColors.textSecondary)
                            .padding(.vertical, 12)
                    }
                    .scaleEffect(1.0)
                    .animation(.easeOut(duration: 0.6).delay(1), value: rowsKnit)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
    
    private func saveSession() {
        if let projectId = appState.selectedProjectId {
            projectStore.saveSession(
                projectId: projectId,
                rowsKnit: rowsKnit,
                timeSpent: timeSpent, // in seconds
                startTime: sessionStartTime
            )
        }
        appState.navigateTo(.dashboard)
    }
}

// MARK: - Supporting Views

struct SessionSparkleView: View {
    let delay: Double
    @State private var isAnimating = false
    
    var body: some View {
        Image(systemName: "sparkles")
            .font(.title2)
            .foregroundColor(Color.yellow.opacity(0.8))
            .scaleEffect(isAnimating ? 1.0 : 0.0)
            .opacity(isAnimating ? 1.0 : 0.0)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct SleepingMascotView: View {
    @State private var zzzOpacity1 = 0.0
    @State private var zzzOpacity2 = 0.0
    @State private var zzzOpacity3 = 0.0
    
    var body: some View {
        ZStack {
            // Yarn Ball Body (sleeping position - ellipse)
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            ThemeColors.primaryDark
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 80)
            
            // Yarn Texture
            VStack(spacing: 6) {
                Path { path in
                    path.move(to: CGPoint(x: 25, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 75, y: 0), control: CGPoint(x: 50, y: -2))
                }
                .stroke(Color(red: 0.62, green: 0.71, blue: 0.59), lineWidth: 1.5)
                
                Path { path in
                    path.move(to: CGPoint(x: 25, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 75, y: 0), control: CGPoint(x: 50, y: 2))
                }
                .stroke(Color(red: 0.62, green: 0.71, blue: 0.59), lineWidth: 1.5)
                
                Path { path in
                    path.move(to: CGPoint(x: 25, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 75, y: 0), control: CGPoint(x: 50, y: -2))
                }
                .stroke(Color(red: 0.62, green: 0.71, blue: 0.59), lineWidth: 1.5)
            }
            
            // Highlight
            Ellipse()
                .fill(.white.opacity(0.4))
                .frame(width: 40, height: 24)
                .offset(x: -12, y: -12)
            
            // Closed Sleeping Eyes
            HStack(spacing: 16) {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 8, y: 0), control: CGPoint(x: 4, y: 2))
                }
                .stroke(.black, lineWidth: 2.5)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 8, y: 0), control: CGPoint(x: 4, y: 2))
                }
                .stroke(.black, lineWidth: 2.5)
            }
            .offset(y: -8)
            
            // Content Smile
            Path { path in
                path.move(to: CGPoint(x: -8, y: 12))
                path.addQuadCurve(to: CGPoint(x: 8, y: 12), control: CGPoint(x: 0, y: 18))
            }
            .stroke(.black, lineWidth: 2)
            
            // Rosy Cheeks
            HStack(spacing: 36) {
                Ellipse()
                    .fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6))
                    .frame(width: 10, height: 6)
                Ellipse()
                    .fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6))
                    .frame(width: 10, height: 6)
            }
            .offset(y: 4)
            
            // Zzz Icons
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("Z")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ThemeColors.primary)
                            .opacity(zzzOpacity1)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(0.8), value: zzzOpacity1)
                        
                        Text("Z")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(ThemeColors.primary)
                            .opacity(zzzOpacity2)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1.0), value: zzzOpacity2)
                        
                        Text("Z")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(ThemeColors.primary)
                            .opacity(zzzOpacity3)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1.2), value: zzzOpacity3)
                    }
                    .offset(x: -32, y: -16)
                }
                Spacer()
            }
        }
        .onAppear {
            zzzOpacity1 = 1.0
            zzzOpacity2 = 1.0
            zzzOpacity3 = 1.0
        }
    }
}

// MARK: - Data Models

struct SparkleData {
    let x: Double
    let y: Double
    let delay: Double
}

#Preview {
    SessionSummaryView(rowsKnit: 12, timeSpent: 1800, sessionStartTime: Date())
        .environmentObject(AppState())
        .environmentObject(ProjectStore())
}
