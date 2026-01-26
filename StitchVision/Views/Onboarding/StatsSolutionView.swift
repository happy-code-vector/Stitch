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
            // Main yarn ball body with excited expression
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
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Yarn texture lines
            ForEach(0..<6, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 30 * .pi / 180
                    let radius: CGFloat = 50
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
            
            // Excited sparkly eyes
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
            }
            .offset(y: -8)
            
            // Raised excited eyebrows
            HStack(spacing: 20) {
                Path { path in
                    path.move(to: CGPoint(x: -3, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 7, y: -1), control: CGPoint(x: 2, y: -5))
                }
                .stroke(Color.black, lineWidth: 2)
                
                Path { path in
                    path.move(to: CGPoint(x: -7, y: -1))
                    path.addQuadCurve(to: CGPoint(x: 3, y: -2), control: CGPoint(x: -2, y: -5))
                }
                .stroke(Color.black, lineWidth: 2)
            }
            .offset(y: -20)
            
            // Big happy smile
            Path { path in
                path.move(to: CGPoint(x: -20, y: 20))
                path.addQuadCurve(to: CGPoint(x: 20, y: 20), control: CGPoint(x: 0, y: 32))
            }
            .stroke(Color.black, lineWidth: 3)
            
            // Rosy excited cheeks
            HStack(spacing: 40) {
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 16, height: 10)
                    .opacity(0.4)
                
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 16, height: 10)
                    .opacity(0.4)
            }
            .offset(y: 8)
            
            // Raised arms in celebration
            Path { path in
                path.move(to: CGPoint(x: -45, y: -10))
                path.addQuadCurve(to: CGPoint(x: -70, y: -35), control: CGPoint(x: -65, y: -15))
            }
            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
            .opacity(0.8)
            
            Path { path in
                path.move(to: CGPoint(x: 45, y: -10))
                path.addQuadCurve(to: CGPoint(x: 70, y: -35), control: CGPoint(x: 65, y: -15))
            }
            .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 8)
            .opacity(0.8)
            
            // Sparkles around mascot
            ForEach(0..<4, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [(-50, -25), (50, -25), (-40, 30), (50, 30)]
                let position = positions[index]
                
                Text("✨")
                    .font(.title2)
                    .offset(x: position.0, y: position.1)
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
        .onAppear {
            sparkleAnimation = true
        }
    }
}