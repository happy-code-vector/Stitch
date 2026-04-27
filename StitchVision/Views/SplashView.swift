import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateVideo = false
    @State private var animateTitle = false
    @State private var animateButton = false

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            FloatingConfettiView()

            VStack {
                Spacer()

                // Character video
                LoopingVideoPlayerView(videoName: "character")
                    .frame(width: 260, height: 260)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    .scaleEffect(animateVideo ? 1.0 : 0.7)
                    .opacity(animateVideo ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: animateVideo)

                Spacer()
                    .frame(height: 48)

                // App name and tagline — pushed further below
                VStack(spacing: 8) {
                    Text("StitchVision")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(ThemeColors.textPrimary)
                        .opacity(animateTitle ? 1.0 : 0.0)
                        .offset(y: animateTitle ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.5), value: animateTitle)

                    Text("Your Knitting Co-Pilot")
                        .font(.title3)
                        .foregroundColor(ThemeColors.textSecondary)
                        .opacity(animateTitle ? 1.0 : 0.0)
                        .offset(y: animateTitle ? 0 : 20)
                        .animation(.easeOut(duration: 0.8).delay(0.6), value: animateTitle)
                }

                Spacer()

                // Get Started Button
                Button(action: {
                    appState.navigateTo(.struggle)
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ThemeColors.primary)
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .scaleEffect(animateButton ? 1.0 : 0.9)
                .opacity(animateButton ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.8), value: animateButton)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateVideo = true
            animateTitle = true
            animateButton = true
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}
