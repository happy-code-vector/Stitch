import SwiftUI

struct FreeTierWelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var animateSparkles = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Blurred background elements to simulate home screen
            VStack(spacing: 16) {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 64)
                    .cornerRadius(16)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                    .padding(.top, 80)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 128)
                    .cornerRadius(24)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 96)
                    .cornerRadius(24)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                Capsule()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 80)
                    .blur(radius: 8)
                    .opacity(0.4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
            }
            
            // Dark overlay
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .animation(.easeOut(duration: 0.8), value: animateElements)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                Spacer()
                
                // Modal content
                VStack(spacing: 0) {
                    // Mascot with folder (floating above modal)
                    MascotWithFolderView()
                        .offset(y: -60)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateElements)
                    
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Welcome to the Starter Plan!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .multilineTextAlignment(.center)
                            
                            Text("You have access to **1 Active Smart Project** with full AI Vision features. Finish it to start a new one, or upgrade anytime to multitask.")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 10)
                        .animation(.easeOut(duration: 0.5).delay(0.4), value: animateElements)
                        
                        Button(action: {
                            appState.navigateTo(.dashboard)
                        }) {
                            Text("Let's Cast On!")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
                                )
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 10)
                        .animation(.easeOut(duration: 0.5).delay(0.6), value: animateElements)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .padding(.top, 40) // Extra space for floating mascot
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                }
                .padding(.horizontal, 24)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateElements)
                
                Spacer()
            }
            
            // Sparkle decorations
            SparkleView(x: 80, y: 120, delay: 0)
            SparkleView(x: 300, y: 200, delay: 0.7)
        }
        .onAppear {
            animateElements = true
            animateSparkles = true
        }
    }
}

struct MascotWithFolderView: View {
    var body: some View {
        ZStack {
            // Project folder/ticket held up
            VStack {
                ZStack {
                    // Golden folder
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.957, green: 0.898, blue: 0.627),
                                    Color(red: 0.831, green: 0.686, blue: 0.216),
                                    Color(red: 0.788, green: 0.635, blue: 0.196)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 0.788, green: 0.635, blue: 0.196), lineWidth: 1.5)
                        )
                    
                    // Folder tab
                    Path { path in
                        path.move(to: CGPoint(x: -30, y: -15))
                        path.addLine(to: CGPoint(x: -30, y: -20))
                        path.addQuadCurve(to: CGPoint(x: -25, y: -25), control: CGPoint(x: -30, y: -25))
                        path.addLine(to: CGPoint(x: -10, y: -25))
                        path.addLine(to: CGPoint(x: -5, y: -15))
                        path.closeSubpath()
                    }
                    .fill(Color(red: 0.831, green: 0.686, blue: 0.216))
                    .overlay(
                        Path { path in
                            path.move(to: CGPoint(x: -30, y: -15))
                            path.addLine(to: CGPoint(x: -30, y: -20))
                            path.addQuadCurve(to: CGPoint(x: -25, y: -25), control: CGPoint(x: -30, y: -25))
                            path.addLine(to: CGPoint(x: -10, y: -25))
                            path.addLine(to: CGPoint(x: -5, y: -15))
                        }
                        .stroke(Color(red: 0.788, green: 0.635, blue: 0.196), lineWidth: 1)
                    )
                    
                    // "1" on folder
                    Text("1")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.788, green: 0.635, blue: 0.196))
                }
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .offset(y: -30)
                
                // Mascot holding folder
                ZStack {
                    // Main yarn ball body
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.76, blue: 0.63),
                                    Color(red: 0.561, green: 0.659, blue: 0.533)
                                ],
                                center: .topLeading,
                                startRadius: 20,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
                    // Yarn texture lines
                    ForEach(0..<5, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 36 * .pi / 180
                            let radius: CGFloat = 32
                            let startX = cos(angle) * radius * 0.3
                            let startY = sin(angle) * radius * 0.3
                            let endX = cos(angle) * radius * 0.7
                            let endY = sin(angle) * radius * 0.7
                            
                            path.move(to: CGPoint(x: startX, y: startY))
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                        .opacity(0.6)
                    }
                    
                    // Happy eyes
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 3, height: 3)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 3, height: 3)
                    }
                    .offset(y: -6)
                    
                    // Proud smile
                    Path { path in
                        path.move(to: CGPoint(x: -10, y: 12))
                        path.addQuadCurve(to: CGPoint(x: 10, y: 12), control: CGPoint(x: 0, y: 18))
                    }
                    .stroke(Color.black, lineWidth: 2)
                    
                    // Arms holding folder (simplified as small extensions)
                    Ellipse()
                        .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                        .frame(width: 12, height: 8)
                        .offset(x: -25, y: -15)
                    
                    Ellipse()
                        .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                        .frame(width: 12, height: 8)
                        .offset(x: 25, y: -15)
                }
            }
        }
    }
}

struct SparkleView: View {
    let x: CGFloat
    let y: CGFloat
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        Text("✨")
            .font(.title3)
            .foregroundColor(Color(red: 0.831, green: 0.686, blue: 0.216))
            .position(x: x, y: y)
            .scaleEffect(animate ? 1.5 : 0.5)
            .opacity(animate ? 1.0 : 0.3)
            .animation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}