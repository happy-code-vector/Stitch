import SwiftUI

struct CraftSelectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCraft: String?
    @State private var animateElements = false

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            // Background image
            VStack {
                Spacer()
                Image("craft_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 400)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [ThemeColors.background, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Progress bar (step 3 of 8)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(height: 6)
                        Rectangle()
                            .fill(ThemeColors.primary)
                            .frame(width: animateElements ? geo.size.width * (3.0/8.0) : geo.size.width * (2.0/8.0), height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .animation(.easeOut(duration: 0.8), value: animateElements)
                    }
                }
                .frame(height: 6)

                // Back button
                HStack {
                    BackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()

                // Header
                Text("What is your main craft?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                // Craft cards
                VStack(spacing: 20) {
                    CraftLargeCard(
                        craftType: "knitting",
                        label: "Knitting",
                        iconSystemName: "scissors",
                        isSelected: selectedCraft == "knitting",
                        delay: 0.2
                    ) {
                        selectedCraft = "knitting"
                    }

                    CraftLargeCard(
                        craftType: "crochet",
                        label: "Crochet",
                        iconSystemName: "flowchart.fill",
                        isSelected: selectedCraft == "crochet",
                        delay: 0.3
                    ) {
                        selectedCraft = "crochet"
                    }
                }
                .padding(.horizontal, 48)

                Spacer()

                // Continue button
                Button(action: {
                    appState.selectedCraft = selectedCraft
                    appState.navigateTo(.skill)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            selectedCraft != nil
                            ? ThemeColors.primary
                            : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedCraft == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct CraftLargeCard: View {
    let craftType: String
    let label: String
    let iconSystemName: String
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void

    @State private var animate = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ThemeColors.primary.opacity(0.1))
                        .frame(width: 80, height: 80)
                    Image(systemName: iconSystemName)
                        .font(.system(size: 36))
                        .foregroundColor(isSelected ? ThemeColors.primary : ThemeColors.textSecondary)
                }

                Text(label)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? ThemeColors.primary : ThemeColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color.white.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(isSelected ? ThemeColors.primary : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(isSelected ? 0.1 : 0.04), radius: isSelected ? 12 : 6, x: 0, y: isSelected ? 6 : 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(animate ? 1.0 : 0.9)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    CraftSelectionView()
        .environmentObject(AppState())
}
