import SwiftUI

struct StruggleView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedStruggle: String?
    @State private var animateElements = false

    let struggles = [
        ("losing-count", "Losing count", "Recounting rows is exhausting"),
        ("dropping-stitches", "Dropping stitches", "Finding mistakes too late")
    ]

    var body: some View {
        GeometryReader { _ in
        VStack(spacing: 0) {
            // Progress bar (step 1 of 8) + Back button row
            HStack(spacing: 0) {
                Button(action: { appState.goBack() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .frame(width: 40, height: 40)
                }

                GeometryReader { barGeo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                        Rectangle()
                            .fill(ThemeColors.primary)
                            .frame(width: barGeo.size.width * (1.0/8.0), height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .animation(.easeOut(duration: 0.8), value: animateElements)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 16)

                Color.clear.frame(width: 40)
            }
            .padding(.horizontal, 24)

            // Content area
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
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
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                    VStack(spacing: 16) {
                        ForEach(struggles, id: \.0) { struggle in
                            FrustrationCard(
                                id: struggle.0,
                                title: struggle.1,
                                description: struggle.2,
                                isSelected: selectedStruggle == struggle.0
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedStruggle = struggle.0
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }

            // Continue button
            Button(action: {
                if let struggle = selectedStruggle {
                    appState.struggles = [struggle]
                }
                appState.navigateTo(.statsProblem)
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        selectedStruggle != nil
                        ? ThemeColors.primary
                        : Color.gray.opacity(0.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .disabled(selectedStruggle == nil)
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
            .padding(.top, 16)
            .opacity(animateElements ? 1.0 : 0.0)
            .offset(y: animateElements ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
        }
        .background(
            ZStack {
                ThemeColors.background
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
            }
            .ignoresSafeArea()
        )
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
                    Circle()
                        .stroke(
                            isSelected ? ThemeColors.primary : Color.gray.opacity(0.3),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
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
                        .font(.system(size: 14))
                        .foregroundColor(ThemeColors.textSecondary)
                }

                Spacer()
            }
            .padding(24)
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
