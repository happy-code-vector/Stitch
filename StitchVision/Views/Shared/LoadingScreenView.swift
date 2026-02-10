import SwiftUI

struct LoadingScreenView: View {
    let onComplete: () -> Void
    
    @State private var messageIndex = 0
    @State private var progress: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var dotOpacity: [Double] = [0.3, 0.3, 0.3]
    
    let loadingMessages = [
        "Analyzing your profile...",
        "Calibrating AI Model...",
        "Finding perfect patterns..."
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Rolling Yarn Ball Mascot
            LoadingScreenRollingYarnBallView(rotationAngle: $rotationAngle)
            
            // Yarn Thread becoming Loading Bar
            VStack(spacing: 16) {
                // Loading Bar
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 12)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                    Color(red: 0.659, green: 0.753, blue: 0.631)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: UIScreen.main.bounds.width * 0.7 * progress, height: 12)
                    
                    // Shimmer effect
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 100, height: 12)
                        .offset(x: -100 + (UIScreen.main.bounds.width * 0.7 + 200) * progress)
                }
                .frame(width: UIScreen.main.bounds.width * 0.7)
            }
            
            // Cycling Text
            ZStack {
                ForEach(Array(loadingMessages.enumerated()), id: \.offset) { index, message in
                    Text(message)
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .opacity(messageIndex == index ? 1.0 : 0.0)
                        .offset(y: messageIndex == index ? 0 : (messageIndex > index ? -10 : 10))
                        .animation(.easeInOut(duration: 0.5), value: messageIndex)
                }
            }
            .frame(height: 30)
            
            // Tech accent dots
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: 8, height: 8)
                        .opacity(dotOpacity[index])
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Rotation animation
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Message cycling
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation {
                messageIndex = (messageIndex + 1) % loadingMessages.count
            }
        }
        
        // Progress animation
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if progress >= 1.0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            } else {
                withAnimation(.linear(duration: 0.03)) {
                    progress += 0.01
                }
            }
        }
        
        // Dot animation
        animateDots()
    }
    
    private func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                for i in 0..<3 {
                    let delay = Double(i) * 0.2
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        dotOpacity[i] = dotOpacity[i] == 0.3 ? 1.0 : 0.3
                    }
                }
            }
        }
    }
}

struct LoadingScreenRollingYarnBallView: View {
    @Binding var rotationAngle: Double
    
    var body: some View {
        ZStack {
            // Unspooling yarn thread
            Path { path in
                path.move(to: CGPoint(x: 80, y: 160))
                path.addQuadCurve(
                    to: CGPoint(x: 80, y: 240),
                    control: CGPoint(x: 70, y: 200)
                )
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .opacity(0.6)
            
            // Rolling mascot
            ZStack {
                // Main yarn ball body
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(width: 100, height: 100)
                
                // Texture layers for 3D fuzzy effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.659, green: 0.753, blue: 0.631).opacity(0.6),
                                Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3),
                                Color(red: 0.490, green: 0.569, blue: 0.463).opacity(0.5)
                            ],
                            center: .topLeading,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)
                
                // Yarn texture lines
                ForEach(0..<4, id: \.self) { i in
                    Path { path in
                        let y = 40 + CGFloat(i) * 15
                        path.move(to: CGPoint(x: 30, y: y))
                        path.addQuadCurve(
                            to: CGPoint(x: 130, y: y),
                            control: CGPoint(x: 80, y: y - 5)
                        )
                    }
                    .stroke(Color(red: 0.616, green: 0.722, blue: 0.588), lineWidth: 2)
                    .opacity(0.6)
                }
                
                // Diagonal yarn wraps
                Path { path in
                    path.move(to: CGPoint(x: 45, y: 35))
                    path.addQuadCurve(
                        to: CGPoint(x: 80, y: 85),
                        control: CGPoint(x: 60, y: 60)
                    )
                }
                .stroke(Color(red: 0.616, green: 0.722, blue: 0.588), lineWidth: 2)
                .opacity(0.4)
                
                Path { path in
                    path.move(to: CGPoint(x: 115, y: 35))
                    path.addQuadCurve(
                        to: CGPoint(x: 80, y: 85),
                        control: CGPoint(x: 100, y: 60)
                    )
                }
                .stroke(Color(red: 0.616, green: 0.722, blue: 0.588), lineWidth: 2)
                .opacity(0.4)
                
                // Stitch marker eyes
                HStack(spacing: 30) {
                    Circle()
                        .fill(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 5, height: 5)
                                .offset(x: 2, y: -2)
                        )
                    
                    Circle()
                        .fill(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 5, height: 5)
                                .offset(x: 2, y: -2)
                        )
                }
                .offset(y: -5)
                
                // Calm, focused expression
                Path { path in
                    path.move(to: CGPoint(x: 60, y: 90))
                    path.addQuadCurve(
                        to: CGPoint(x: 100, y: 90),
                        control: CGPoint(x: 80, y: 95)
                    )
                }
                .stroke(Color(red: 0.173, green: 0.173, blue: 0.173), lineWidth: 2.5)
                
                // Highlight for 3D effect
                Ellipse()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 36, height: 26)
                    .offset(x: -15, y: -20)
            }
            .rotationEffect(.degrees(rotationAngle))
            
            // Small yarn tail coming off the ball
            Path { path in
                path.move(to: CGPoint(x: 130, y: 50))
                path.addQuadCurve(
                    to: CGPoint(x: 160, y: 60),
                    control: CGPoint(x: 145, y: 45)
                )
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .rotationEffect(.degrees(rotationAngle * 0.5))
        }
        .frame(width: 160, height: 160)
    }
}

#Preview {
    LoadingScreenView(onComplete: {})
}
