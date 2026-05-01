import SwiftUI

struct StruggleView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedStruggles: Set<String> = []
    @State private var animateElements = false

    let struggles = [
        ("losing-count", "Losing count", "Recounting rows is exhausting"),
        ("dropping-stitches", "Dropping stitches", "Finding mistakes too late"),
        ("complex-patterns", "Following complex patterns", "Getting lost mid-project"),
        ("multiple-projects", "Keeping track of multiple projects", "Too many WIPs, too much chaos")
    ]

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            // Background image
            VStack {
                Image("frustration_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, ThemeColors.background],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Spacer()
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Back button + Progress bar (step 1 of 8)
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
                                .frame(width: animateElements ? (geo.size.width - 112) * (1.0/8.0) : 0, height: 6)
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
                VStack(spacing: 12) {
                    Text("What frustrates you most?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(ThemeColors.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Let's fix the things that hold you back")
                        .font(.body)
                        .foregroundColor(ThemeColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : -20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                Spacer()

                // Struggle options
                VStack(spacing: 16) {
                    ForEach(struggles, id: \.0) { struggle in
                        FrustrationCard(
                            id: struggle.0,
                            title: struggle.1,
                            description: struggle.2,
                            isSelected: selectedStruggles.contains(struggle.0)
                        ) {
                            if selectedStruggles.contains(struggle.0) {
                                selectedStruggles.remove(struggle.0)
                            } else {
                                selectedStruggles.insert(struggle.0)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // Continue button
                Button(action: {
                    appState.struggles = Array(selectedStruggles)
                    appState.navigateTo(.statsProblem)
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            !selectedStruggles.isEmpty
                            ? ThemeColors.primary
                            : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(28)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .disabled(selectedStruggles.isEmpty)
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

struct FrustrationCard: View {
    let id: String
    let title: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(
                            isSelected ? ThemeColors.primary : Color.gray.opacity(0.3),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(ThemeColors.primary)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(isSelected ? ThemeColors.primary : ThemeColors.textPrimary)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.textSecondary)
                }

                Spacer()
            }
            .padding(20)
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? ThemeColors.primary : Color.clear, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    StruggleView()
        .environmentObject(AppState())
}
