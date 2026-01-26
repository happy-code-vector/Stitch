import SwiftUI

struct PermissionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var animateBackground = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Background pattern
            Canvas { context, size in
                let rows = Int(size.height / 80)
                let cols = Int(size.width / 80)
                
                for row in 0..<rows {
                    for col in 0..<cols {
                        let x = CGFloat(col) * 80 + 20
                        let y = CGFloat(row) * 80 + 20
                        let offset: CGFloat = row % 2 == 0 ? 0 : 40
                        
                        context.fill(
                            Path(ellipseIn: CGRect(x: x + offset, y: y, width: 4, height: 4)),
                            with: .color(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                        )
                    }
                }
            }
            
            // Decorative background circles
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 120, height: 120)
                .blur(radius: 40)
                .offset(x: 80, y: -150)
                .scaleEffect(animateBackground ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateBackground)
            
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: -80, y: 200)
                .scaleEffect(animateBackground ? 1.0 : 1.3)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true).delay(1), value: animateBackground)
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .scaleEffect(x: 0.95, y: 1, anchor: .leading)
                        .animation(.easeOut(duration: 0.8), value: animateElements)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                Spacer()
                
                // Modal content
                VStack(spacing: 24) {
                    // Bell icon with gradient background
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
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "bell.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2), value: animateElements)
                    
                    VStack(spacing: 16) {
                        Text("Don't lose your streak")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                        
                        Text("Allow notifications so the AI Coach can remind you to finish that sweater.")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: animateElements)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            // Request notification permission here
                            appState.navigateTo(.freeTierWelcome)
                        }) {
                            Text("Allow")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            appState.navigateTo(.freeTierWelcome)
                        }) {
                            Text("Maybe Later")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(.vertical, 12)
                        }
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.5).delay(0.5), value: animateElements)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 32)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                
                Spacer()
            }
        }
        .onAppear {
            animateElements = true
            animateBackground = true
        }
    }
}