import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateYarnBall = false
    @State private var animateTitle = false
    @State private var animateButton = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949) // #F9F7F2
                .ignoresSafeArea()
            
            // Floating confetti effect
            FloatingConfettiView()
            
            VStack {
                Spacer()
                
                VStack(spacing: 32) {
                    // Yarn Ball Mascot
                    YarnBallMascotView()
                        .scaleEffect(animateYarnBall ? 1.0 : 0.8)
                        .opacity(animateYarnBall ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.2), value: animateYarnBall)
                    
                    // Title and subtitle
                    VStack(spacing: 8) {
                        Text("StitchVision")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173)) // #2C2C2C
                            .opacity(animateTitle ? 1.0 : 0.0)
                            .offset(y: animateTitle ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateTitle)
                        
                        Text("Your Knitting Co-Pilot")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4)) // #666666
                            .opacity(animateTitle ? 1.0 : 0.0)
                            .offset(y: animateTitle ? 0 : 20)
                            .animation(.easeOut(duration: 0.8).delay(0.5), value: animateTitle)
                    }
                }
                
                Spacer()
                
                // Get Started Button
                Button(action: {
                    appState.navigateTo(.craft)
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533)) // #8FA888
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .scaleEffect(animateButton ? 1.0 : 0.9)
                .opacity(animateButton ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.6), value: animateButton)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            animateYarnBall = true
            animateTitle = true
            animateButton = true
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}