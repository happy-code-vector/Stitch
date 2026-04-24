import SwiftUI

struct ProGateView: View {
    let onUpgrade: () -> Void
    let onSkip: () -> Void

    @State private var animateElements = false

    var body: some View {
        ZStack {
            // Background
            ThemeColors.background
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Pro Badge Icon
                ZStack {
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
                        .frame(width: 120, height: 120)
                        .shadow(color: Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.4), radius: 20, x: 0, y: 10)

                    Image(systemName: "crown.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                }
                .scaleEffect(animateElements ? 1.0 : 0.8)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animateElements)

                VStack(spacing: 12) {
                    Text("AI Calibration")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ThemeColors.textPrimary)

                    Text("is a Pro Feature")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : -20)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)

                VStack(spacing: 16) {
                    ProGateBenefitRow(
                        icon: "eye.fill",
                        text: "Personalized AI calibration"
                    )

                    ProGateBenefitRow(
                        icon: "chart.line.uptrend.xyaxis",
                        text: "99.7% accuracy for your style"
                    )

                    ProGateBenefitRow(
                        icon: "infinity",
                        text: "Unlimited pattern uploads"
                    )

                    ProGateBenefitRow(
                        icon: "icloud.fill",
                        text: "Cloud sync across devices"
                    )
                }
                .padding(.horizontal, 32)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)

                Spacer()

                VStack(spacing: 16) {
                    Button(action: onUpgrade) {
                        Text("Upgrade to Pro")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.49, green: 0.57, blue: 0.46)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.4), radius: 12, x: 0, y: 6)
                    }

                    Button(action: onSkip) {
                        Text("Skip for Now")
                            .font(.subheadline)
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct ProGateBenefitRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }

            Text(text)
                .font(.body)
                .foregroundColor(ThemeColors.textPrimary)

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProGateView(
        onUpgrade: { print("Upgrade tapped") },
        onSkip: { print("Skip tapped") }
    )
}
