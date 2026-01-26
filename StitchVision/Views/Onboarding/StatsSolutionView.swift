import SwiftUI

struct StatsSolutionView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateStats = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Background sparkle elements
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 128, height: 128)
                .blur(radius: 30)
                .position(x: UIScreen.main.bounds.width - 80, y: 120)
                .scaleEffect(animateStats ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateStats)
            
            Circle()
                .fill(Color(red: 0.831, green: 0.686, blue: 0.216).opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .position(x: 80, y: UIScreen.main.bounds.height - 160)
                .scaleEffect(animateStats ? 1.3 : 1.0)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true).delay(1), value: animateStats)
            
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 0)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Excited Mascot
                        ExcitedMascotView()
                            .scaleEffect(animateStats ? 1.0 : 0.8)
                            .opacity(animateStats ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animateStats)
                        
                        // Headline
                        Text("With AI, Everything Changes")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateStats ? 1.0 : 0.0)
                            .offset(y: animateStats ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateStats)
                        
                        // Subtext
                        Text("StitchVision users see incredible results:")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .opacity(animateStats ? 1.0 : 0.0)
                            .offset(y: animateStats ? 0 : 10)
                            .animation(.easeOut(duration: 0.6).delay(0.3), value: animateStats)
                        
                        // Stats Cards - Positive outcomes
                        VStack(spacing: 16) {
                            SolutionStatCardView(
                                icon: "sparkles",
                                statNumber: "4+ hours",
                                statLabel: "saved per project",
                                description: "AI counts automatically—no more manual tracking",
                                delay: 0.4
                            )
                            
                            SolutionStatCardView(
                                icon: "chart.line.uptrend.xyaxis",
                                statNumber: "2x faster",
                                statLabel: "project completion",
                                description: "Finish scarves, sweaters, and blankets in half the time",
                                delay: 0.5
                            )
                            
                            SolutionStatCardView(
                                icon: "award.fill",
                                statNumber: "92%",
                                statLabel: "finish every project",
                                description: "No more abandoned WIPs (works in progress)",
                                delay: 0.6
                            )
                        }
                        
                        // Highlight message
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                Text("The Bottom Line")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Image(systemName: "sparkles")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 8)
                            
                            Text("You'll knit **more projects** in **less time**, with **zero frustration**.")
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                    Color(red: 0.66, green: 0.76, blue: 0.63)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .scaleEffect(animateStats ? 1.0 : 0.9)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateStats)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.loading)
                        }) {
                            Text("Let's Get Started!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                        }
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: animateStats)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateStats = true
        }
    }
}

struct SolutionStatCardView: View {
    let icon: String
    let statNumber: String
    let statLabel: String
    let description: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon circle
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(statNumber)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                
                Text(statLabel)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
                .padding(.leading, 0)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 1.5)
                )
                .mask(
                    Rectangle()
                        .frame(width: 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
        )
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -30)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct ExcitedMascotView: View {
    @State private var sparkleAnimation = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)

                ZStack {
                    // Main yarn ball body with excited expression
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.76, blue: 0.63),
                                    Color(red: 0.561, green: 0.659, blue: 0.533)
                                ],
                                center: .topLeading,
                                startRadius: size * 0.18,
                                endRadius: size * 0.6
                            )
                        )
                        .frame(width: size * 0.8, height: size * 0.8)
                        .position(center)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Yarn texture lines
                    ForEach(0..<6, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 30 * .pi / 180
                            let radius: CGFloat = size * 0.35
                            let start = CGPoint(
                                x: center.x + cos(angle) * radius * 0.3,
                                y: center.y + sin(angle) * radius * 0.3
                            )
                            let end = CGPoint(
                                x: center.x + cos(angle) * radius * 0.7,
                                y: center.y + sin(angle) * radius * 0.7
                            )
                            path.move(to: start)
                            path.addLine(to: end)
                        }
                        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                        .opacity(0.6)
                    }

                    // Eyes
                    Group {
                        let eyeOffsetY = size * 0.08
                        let eyeSpacing = size * 0.12
                        Circle()
                            .fill(Color.black)
                            .frame(width: size * 0.04, height: size * 0.04)
                            .position(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                        Circle()
                            .fill(Color.black)
                            .frame(width: size * 0.04, height: size * 0.04)
                            .position(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)
                    }

                    // Raised excited eyebrows above each eye
                    Group {
                        let eyeOffsetY = size * 0.08
                        let eyeSpacing = size * 0.12
                        let leftEyeCenter = CGPoint(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                        let rightEyeCenter = CGPoint(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)

                        Path { path in
                            let start = CGPoint(x: leftEyeCenter.x - size * 0.06, y: leftEyeCenter.y - size * 0.07)
                            let end = CGPoint(x: leftEyeCenter.x + size * 0.06, y: leftEyeCenter.y - size * 0.07)
                            let control = CGPoint(x: leftEyeCenter.x, y: leftEyeCenter.y - size * 0.11)
                            path.move(to: start)
                            path.addQuadCurve(to: end, control: control)
                        }
                        .stroke(Color.black, lineWidth: 2)

                        Path { path in
                            let start = CGPoint(x: rightEyeCenter.x - size * 0.06, y: rightEyeCenter.y - size * 0.07)
                            let end = CGPoint(x: rightEyeCenter.x + size * 0.06, y: rightEyeCenter.y - size * 0.07)
                            let control = CGPoint(x: rightEyeCenter.x, y: rightEyeCenter.y - size * 0.11)
                            path.move(to: start)
                            path.addQuadCurve(to: end, control: control)
                        }
                        .stroke(Color.black, lineWidth: 2)
                    }

                    // Big happy smile
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.20, y: center.y + size * 0.14))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.20, y: center.y + size * 0.14),
                            control: CGPoint(x: center.x, y: center.y + size * 0.26)
                        )
                    }
                    .stroke(Color.black, lineWidth: 3)

                    // Rosy excited cheeks
                    Group {
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.12, height: size * 0.07)
                            .opacity(0.4)
                            .position(x: center.x - size * 0.22, y: center.y + size * 0.10)

                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.12, height: size * 0.07)
                            .opacity(0.4)
                            .position(x: center.x + size * 0.22, y: center.y + size * 0.10)
                    }

                    // Raised arms in celebration
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.30, y: center.y - size * 0.06))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x - size * 0.46, y: center.y - size * 0.22),
                            control: CGPoint(x: center.x - size * 0.40, y: center.y - size * 0.08)
                        )
                    }
                    .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
                    .opacity(0.8)

                    Path { path in
                        path.move(to: CGPoint(x: center.x + size * 0.30, y: center.y - size * 0.06))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.46, y: center.y - size * 0.22),
                            control: CGPoint(x: center.x + size * 0.40, y: center.y - size * 0.08)
                        )
                    }
                    .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
                    .opacity(0.8)

                    // Sparkles around mascot
                    ForEach(0..<4, id: \.self) { index in
                        let positions: [(CGFloat, CGFloat)] = [(-0.32, -0.20), (0.32, -0.20), (-0.28, 0.22), (0.32, 0.22)]
                        let p = positions[index]
                        Text("✨")
                            .font(.title2)
                            .position(x: center.x + size * p.0, y: center.y + size * p.1)
                            .scaleEffect(sparkleAnimation ? 1.5 : 0.5)
                            .opacity(sparkleAnimation ? 1.0 : 0.0)
                            .animation(
                                .easeInOut(duration: 2)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: sparkleAnimation
                            )
                    }
                }
            }
        }
        .frame(width: 160, height: 160)
        .onAppear {
            sparkleAnimation = true
        }
    }
}
