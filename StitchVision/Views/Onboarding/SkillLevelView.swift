import SwiftUI

struct SkillLevelView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSkill: String?
    @State private var animateElements = false

    let skillLevels = [
        ("beginner", "Beginner", "Just starting my journey", "sprout", Color(red: 0.22, green: 0.75, blue: 0.39)),
        ("intermediate", "Intermediate", "I know the basics well", "layers.3", ThemeColors.primary),
        ("advanced", "Advanced", "A seasoned master maker", "star.fill", Color(red: 0.96, green: 0.75, blue: 0.15))
    ]

    var body: some View {
        ZStack(alignment: .top) {
            // Full-screen subtle background at 10% opacity — matching HTML
            ThemeColors.background
                .overlay(
                    Image("skill_bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.1)
                        .ignoresSafeArea()
                )
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar (step 4 of 8) + Back button
                HStack(spacing: 0) {
                    Button(action: { appState.goBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .frame(width: 40, height: 40)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                            Rectangle()
                                .fill(ThemeColors.primary)
                                .frame(width: geo.size.width * (4.0/8.0), height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .animation(.easeOut(duration: 0.8), value: animateElements)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, 16)

                    Color.clear.frame(width: 40)
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)

                Spacer()

                // Header
                Text("What's your skill level?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                // Skill level cards
                VStack(spacing: 24) {
                    ForEach(Array(skillLevels.enumerated()), id: \.offset) { index, skill in
                        SkillLevelCard(
                            skillType: skill.0,
                            title: skill.1,
                            description: skill.2,
                            iconName: skill.3,
                            iconColor: skill.4,
                            isSelected: selectedSkill == skill.0,
                            delay: Double(index) * 0.1 + 0.2
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSkill = skill.0
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Continue button
                Button(action: {
                    appState.skillLevel = selectedSkill
                    appState.navigateTo(.goal)
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            selectedSkill != nil
                            ? ThemeColors.primary
                            : Color.gray.opacity(0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedSkill == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
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

struct SkillLevelCard: View {
    let skillType: String
    let title: String
    let description: String
    let iconName: String
    let iconColor: Color
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void

    @State private var animate = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 64, height: 64)
                    Image(systemName: iconName)
                        .font(.system(size: 30))
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ThemeColors.textPrimary)
                    Text(description)
                        .font(.system(size: 15))
                        .foregroundColor(ThemeColors.textSecondary)
                }

                Spacer()
            }
            .padding(24)
            .background(Color.white.opacity(0.9))
            .background(.ultraThinMaterial)
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
    SkillLevelView()
        .environmentObject(AppState())
}
