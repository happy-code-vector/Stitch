import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var appState: AppState
    @State private var progress: Double = 0
    @State private var messageIndex = 0
    @State private var isAnimating = false
    
    let loadingMessages = [
        "Analyzing your profile...",
        "Calibrating AI Model...",
        "Finding perfect patterns..."
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            // Rolling Yarn Ball Mascot
            RollingYarnBallView()
            
            // Yarn Thread becoming Loading Bar
            VStack(spacing: 16) {
                ZStack {
                    // Background bar
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    // Progress bar
                    HStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.66, green: 0.76, blue: 0.63)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(0, CGFloat(progress) * 200 / 100), height: 12)
                            .animation(.easeInOut(duration: 0.3), value: progress)
                        
                        Spacer()
                    }
                    
                    // Animated shimmer effect
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.white.opacity(0.3), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 12)
                        .offset(x: isAnimating ? 100 : -100)
                        .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isAnimating)
                }
                .frame(width: 200)
            }
            
            // Cycling Text
            VStack {
                Text(loadingMessages[messageIndex])
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
                    .animation(.easeInOut(duration: 0.5), value: messageIndex)
            }
            .frame(height: 24)
            
            // Tech accent dots
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .opacity(isAnimating ? 1.0 : 0.3)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .onAppear {
            isAnimating = true
            startLoading()
        }
    }
    
    private func startLoading() {
        // Cycle through messages
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            messageIndex = (messageIndex + 1) % loadingMessages.count
        }
        
        // Simulate progress
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if progress >= 100 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appState.navigateTo(.result)
                }
            } else {
                progress += 1
            }
        }
    }
}

struct RollingYarnBallView: View {
    @State private var isRotating = false
    @State private var yarnLength: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Rolling mascot
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 60
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    // Yarn texture lines
                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 45 * .pi / 180
                            let radius: CGFloat = 50
                            let startX = cos(angle) * radius * 0.3
                            let startY = sin(angle) * radius * 0.3
                            let endX = cos(angle) * radius * 0.7
                            let endY = sin(angle) * radius * 0.7
                            
                            path.move(to: CGPoint(x: startX, y: startY))
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 2)
                        .opacity(0.6)
                    }
                )
                .overlay(
                    // Eyes
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 4, height: 4)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 4, height: 4)
                    }
                    .offset(y: -8)
                )
                .overlay(
                    // Calm, focused smile
                    Path { path in
                        path.move(to: CGPoint(x: -12, y: 15))
                        path.addQuadCurve(to: CGPoint(x: 12, y: 15), control: CGPoint(x: 0, y: 20))
                    }
                    .stroke(Color.black, lineWidth: 2)
                )
                .rotationEffect(.degrees(isRotating ? 360 : 0))
                .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: isRotating)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Unspooling yarn thread
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: 0, y: yarnLength),
                    control: CGPoint(x: sin(yarnLength * 0.1) * 10, y: yarnLength * 0.5)
                )
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .frame(height: 80)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: yarnLength)
            
            // Small yarn tail
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addQuadCurve(to: CGPoint(x: 20, y: 0), control: CGPoint(x: 10, y: -5))
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .offset(x: 30, y: -40)
            .rotationEffect(.degrees(isRotating ? -10 : 0))
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isRotating)
        }
        .onAppear {
            isRotating = true
            yarnLength = 80
        }
    }
}