import SwiftUI

struct ProActivationConfirmationView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false

    var body: some View {
        ZStack {
            // Solid sage background
            ThemeColors.primary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Checkmark icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                }
                .scaleEffect(animateElements ? 1.0 : 0.8)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animateElements)

                // Headline
                Text("Pro Unlocked.\nYou're All Set.")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : -20)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)

                // Subtext
                Text("Your AI-powered knitting assistant is ready. Here's what you can do:")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)

                // Feature callouts
                VStack(spacing: 16) {
                    ProActivationFeatureRow(text: "Unlimited Projects", delay: 0.4)
                    ProActivationFeatureRow(text: "Unlimited StitchBot", delay: 0.5)
                    ProActivationFeatureRow(text: "Vision Row Counter", delay: 0.6)
                }
                .padding(.horizontal, 40)
                .padding(.top, 32)

                Spacer()

                // Primary CTA
                Button(action: {
                    appState.navigateTo(.calibration)
                }) {
                    Text("Start Calibrating")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 32)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)

                // Secondary CTA
                Button(action: {
                    appState.navigateTo(.dashboard)
                }) {
                    Text("Skip Calibration")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.top, 16)
                .padding(.bottom, 50)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(0.9), value: animateElements)
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

// MARK: - Feature Row

private struct ProActivationFeatureRow: View {
    let text: String
    let delay: Double
    @State private var animate = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())

            Text(text)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Spacer()
        }
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeOut(duration: 0.5).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ProActivationConfirmationView()
        .environmentObject(AppState())
}
