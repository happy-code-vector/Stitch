import SwiftUI

struct GoalSettingView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedGoal: String?
    @State private var animateElements = false

    let goals = [
        ("finish-more", "Finish more projects", "target", Color(red: 0.93, green: 0.30, blue: 0.30)),
        ("relax", "Relax and unwind", "face.smiling", Color(red: 0.96, green: 0.75, blue: 0.15)),
        ("make-gifts", "Make gifts for loved ones", "heart.fill", Color(red: 0.93, green: 0.43, blue: 0.55))
    ]

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            // Background image
            Image("goal_bg")
                .resizable()
                .opacity(0.1)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Back button + Progress bar (step 5 of 8)
                GeometryReader { geo in
                    HStack(spacing: 0) {
                        Button(action: { appState.goBack() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 40, height: 40)

                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(height: 6)
                            Rectangle()
                                .fill(ThemeColors.primary)
                                .frame(width: animateElements ? (geo.size.width - 112) * (5.0/8.0) : 0, height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .animation(.easeOut(duration: 0.8), value: animateElements)
                        }
                        .padding(.horizontal, 16)

                        Color.clear.frame(width: 40)
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()

                // Header
                Text("What's your main goal?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                // Goal options
                VStack(spacing: 12) {
                    ForEach(Array(goals.enumerated()), id: \.offset) { index, goal in
                        GoalCard(
                            id: goal.0,
                            label: goal.1,
                            iconName: goal.2,
                            iconColor: goal.3,
                            isSelected: selectedGoal == goal.0,
                            delay: Double(index) * 0.1 + 0.2
                        ) {
                            selectedGoal = goal.0
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Continue button
                Button(action: {
                    appState.goal = selectedGoal
                    appState.navigateTo(.cameraPermissions)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            selectedGoal != nil
                            ? ThemeColors.primary
                            : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedGoal == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.5), value: animateElements)
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct GoalCard: View {
    let id: String
    let label: String
    let iconName: String
    let iconColor: Color
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void

    @State private var animate = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(iconColor)
                }

                Text(label)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)

                Spacer()
            }
            .padding(20)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isSelected ? ThemeColors.primary : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    GoalSettingView()
        .environmentObject(AppState())
}
