import SwiftUI

struct CraftSelectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCraft: String?
    @State private var animateElements = false

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            // Bottom decorative background (400px) with gradient fade
            GeometryReader { geo in
                VStack {
                    Spacer()
                    ZStack(alignment: .bottom) {
                        Image("craft_bg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 400)
                            .clipped()

                        LinearGradient(
                            colors: [ThemeColors.background, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 400)
                    }
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // Main content
            VStack(spacing: 0) {
                // Progress bar (step 3 of 8) + Back button
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
                                .frame(width: geo.size.width * (3.0/8.0), height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .animation(.easeOut(duration: 0.8), value: animateElements)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, 16)

                    Color.clear.frame(width: 40)
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)

                Spacer()

                // Header
                Text("What is your main craft?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(ThemeColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                // Craft cards — large vertical rounded cards with icons
                VStack(spacing: 24) {
                    CraftLargeCard(
                        craftType: "knitting",
                        label: "Knitting",
                        iconName: "knitting_icon",
                        isSelected: selectedCraft == "knitting",
                        delay: 0.2
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCraft = "knitting"
                        }
                    }

                    CraftLargeCard(
                        craftType: "crochet",
                        label: "Crochet",
                        iconName: "crochet_icon",
                        isSelected: selectedCraft == "crochet",
                        delay: 0.3
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCraft = "crochet"
                        }
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
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            selectedCraft != nil
                            ? ThemeColors.primary
                            : Color.gray.opacity(0.5)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedCraft == nil)
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
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
    let iconName: String
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void

    @State private var animate = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 96, height: 96)

                Text(label)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? ThemeColors.primary : ThemeColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(Color.white.opacity(0.95))
            .background(.ultraThinMaterial)
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
