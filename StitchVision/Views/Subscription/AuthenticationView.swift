import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var floatAnimation = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .scaleEffect(x: 0.94, y: 1, anchor: .leading)
                    .animation(.easeOut(duration: 0.8), value: animateElements)
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            
            Spacer()
            
            // Mascot with Cloud Icon
            ZStack {
                // Yarn Ball Mascot
                YarnBallMascotView()
                    .frame(width: 180, height: 180)
                    .offset(y: floatAnimation ? -10 : 0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floatAnimation)
                
                // Cloud Icon
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                .offset(x: 70, y: 70)
                .scaleEffect(animateElements ? 1.0 : 0.0)
                .rotationEffect(.degrees(animateElements ? 0 : -20))
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animateElements)
            }
            .opacity(animateElements ? 1.0 : 0.0)
            .offset(y: animateElements ? 0 : -20)
            .animation(.easeOut(duration: 0.6), value: animateElements)
            
            Spacer().frame(height: 40)
            
            // Title
            Text("Save Your Stash")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                .multilineTextAlignment(.center)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 10)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
            
            Spacer().frame(height: 16)
            
            // Subtitle
            Text("Create a free account to sync your patterns and projects across devices.")
                .font(.body)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 10)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)
            
            Spacer()
            
            // Auth Buttons
            VStack(spacing: 16) {
                // Continue with Apple
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    },
                    onCompletion: { result in
                        switch result {
                        case .success:
                            appState.navigateTo(.dashboard)
                        case .failure(let error):
                            print("Authorization failed: \(error.localizedDescription)")
                        }
                    }
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 56)
                .cornerRadius(28)
                
                // Continue with Google (Custom Button)
                Button(action: {
                    // Google Sign In logic
                    appState.navigateTo(.dashboard)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 20))
                        
                        Text("Continue with Google")
                            .font(.headline)
                    }
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(28)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                }
                
                // Sign up with Email
                Button(action: {
                    // Email sign up logic
                    appState.navigateTo(.dashboard)
                }) {
                    Text("Sign up with Email")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .padding(.horizontal, 32)
            .opacity(animateElements ? 1.0 : 0.0)
            .offset(y: animateElements ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
            
            Spacer()
            
            // Skip Option
            Button(action: {
                appState.navigateTo(.dashboard)
            }) {
                Text("Skip for now (Data saved locally only)")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            .opacity(animateElements ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
            floatAnimation = true
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AppState())
}
