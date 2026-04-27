import SwiftUI

struct StatsProblemView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateStats = false
    @State private var animateElements = false

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            // Background image
            Image("empathy_bg")
                .resizable()
                .opacity(0.1)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Back button + Progress bar (step 2 of 8)
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
                                .frame(width: animateStats ? (geo.size.width - 112) * (2.0/8.0) : (geo.size.width - 112) * (1.0/8.0), height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .animation(.easeOut(duration: 0.8), value: animateStats)
                        }
                        .padding(.horizontal, 16)

                        Color.clear.frame(width: 40)
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: 8) {
                            Text("You're Not Alone")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(ThemeColors.textPrimary)

                            Text("Crafting has its challenges, but we've got you.")
                                .font(.body)
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 32)
                        .padding(.bottom, 32)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                        // Stat cards
                        VStack(spacing: 12) {
                            StatCard(
                                icon: "timer",
                                value: "4+ Hours",
                                label: "Wasted per project",
                                accentColor: Color(red: 0.91, green: 0.478, blue: 0.365),
                                delay: 0.2
                            )

                            StatCard(
                                icon: "exclamationmark.triangle.fill",
                                value: "73%",
                                label: "Lose track of rows",
                                accentColor: Color(red: 0.91, green: 0.478, blue: 0.365),
                                delay: 0.4
                            )
                        }
                        .padding(.horizontal, 24)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6), value: animateStats)

                        // Green message box
                        HStack(spacing: 12) {
                            Text("StitchVision eliminates the guesswork from your first project.")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(red: 0.133, green: 0.302, blue: 0.224))
                                .multilineTextAlignment(.leading)

                            Image(systemName: "heart.text.square")
                                .font(.system(size: 28))
                                .foregroundColor(ThemeColors.primary)
                        }
                        .padding(20)
                        .background(Color(red: 0.929, green: 0.957, blue: 0.918).opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(ThemeColors.primary.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateStats)
                    }
                    .padding(.bottom, 40)
                }

                // Continue button
                Button(action: {
                    appState.navigateTo(.craft)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(ThemeColors.primary)
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateElements = true
            animateStats = true
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let accentColor: Color
    let delay: Double

    @State private var animate = false

    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 1.0, green: 0.933, blue: 0.898))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(accentColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(accentColor)
                Text(label)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)
            }

            Spacer()
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color(red: 1.0, green: 0.933, blue: 0.898), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        .opacity(animate ? 1.0 : 0.0)
        .offset(y: animate ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    StatsProblemView()
        .environmentObject(AppState())
}
