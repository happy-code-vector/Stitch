import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
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
                    VStack(spacing: 32) {
                        // Header with celebrating mascot
                        VStack(spacing: 24) {
                            CelebratingMascotView()
                                .scaleEffect(animateElements ? 1.0 : 0.8)
                                .opacity(animateElements ? 1.0 : 0.0)
                                .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1), value: animateElements)
                            
                            VStack(spacing: 16) {
                                Text("The Results Speak for Themselves")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    .multilineTextAlignment(.center)
                                    .opacity(animateElements ? 1.0 : 0.0)
                                    .offset(y: animateElements ? 0 : -20)
                                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                                
                                Text("See how StitchVision transforms your crafting experience")
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .multilineTextAlignment(.center)
                                    .opacity(animateElements ? 1.0 : 0.0)
                                    .offset(y: animateElements ? 0 : 10)
                                    .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        // Comparison chart
                        ComparisonChartView()
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : 30)
                            .animation(.easeOut(duration: 0.8).delay(0.4), value: animateElements)
                        
                        // Key benefits
                        VStack(spacing: 20) {
                            Text("Why Users Love StitchVision")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .opacity(animateElements ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
                            
                            VStack(spacing: 16) {
                                BenefitCard(
                                    icon: "clock.fill",
                                    title: "Save 4+ Hours Per Project",
                                    description: "No more recounting rows or losing your place",
                                    color: Color(red: 0.831, green: 0.502, blue: 0.435),
                                    delay: 0.7
                                )
                                
                                BenefitCard(
                                    icon: "target",
                                    title: "99.7% Accuracy",
                                    description: "AI-powered precision you can trust",
                                    color: Color(red: 0.561, green: 0.659, blue: 0.533),
                                    delay: 0.8
                                )
                                
                                BenefitCard(
                                    icon: "heart.fill",
                                    title: "Stress-Free Crafting",
                                    description: "Focus on the joy of creating, not counting",
                                    color: Color(red: 0.831, green: 0.686, blue: 0.216),
                                    delay: 0.9
                                )
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.cameraPermissions)
                        }) {
                            Text("Get Started Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                        }
                        .padding(.horizontal, 32)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                    }
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct ComparisonChartView: View {
    @State private var animateChart = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Before vs After StitchVision")
                .font(.headline)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            HStack(spacing: 32) {
                // Before column
                VStack(spacing: 16) {
                    Text("Before")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                    
                    VStack(spacing: 12) {
                        ChartBar(
                            label: "Time Wasted",
                            value: animateChart ? 0.8 : 0,
                            color: Color(red: 0.831, green: 0.502, blue: 0.435),
                            delay: 0.1
                        )
                        
                        ChartBar(
                            label: "Stress Level",
                            value: animateChart ? 0.9 : 0,
                            color: Color(red: 0.831, green: 0.502, blue: 0.435),
                            delay: 0.2
                        )
                        
                        ChartBar(
                            label: "Errors Made",
                            value: animateChart ? 0.7 : 0,
                            color: Color(red: 0.831, green: 0.502, blue: 0.435),
                            delay: 0.3
                        )
                        
                        ChartBar(
                            label: "Projects Finished",
                            value: animateChart ? 0.3 : 0,
                            color: Color(red: 0.831, green: 0.502, blue: 0.435),
                            delay: 0.4
                        )
                    }
                }
                
                // After column
                VStack(spacing: 16) {
                    Text("After")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    
                    VStack(spacing: 12) {
                        ChartBar(
                            label: "Time Saved",
                            value: animateChart ? 0.95 : 0,
                            color: Color(red: 0.561, green: 0.659, blue: 0.533),
                            delay: 0.5
                        )
                        
                        ChartBar(
                            label: "Relaxation",
                            value: animateChart ? 0.9 : 0,
                            color: Color(red: 0.561, green: 0.659, blue: 0.533),
                            delay: 0.6
                        )
                        
                        ChartBar(
                            label: "Accuracy",
                            value: animateChart ? 0.99 : 0,
                            color: Color(red: 0.561, green: 0.659, blue: 0.533),
                            delay: 0.7
                        )
                        
                        ChartBar(
                            label: "Completion Rate",
                            value: animateChart ? 0.92 : 0,
                            color: Color(red: 0.561, green: 0.659, blue: 0.533),
                            delay: 0.8
                        )
                    }
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 32)
        .onAppear {
            animateChart = true
        }
    }
}

struct ChartBar: View {
    let label: String
    let value: Double
    let color: Color
    let delay: Double
    
    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                .multilineTextAlignment(.center)
                .frame(height: 32)
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 80)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(color)
                    .frame(width: 40, height: CGFloat(value) * 80)
                    .cornerRadius(4)
                    .animation(.easeOut(duration: 1.0).delay(delay), value: value)
            }
            
            Text("\(Int(value * 100))%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

struct BenefitCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(color.opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text(description)
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -30)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct CelebratingMascotView: View {
    @State private var celebrateAnimation = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)

                ZStack {
                    // Main yarn ball body with celebrating expression
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

                    // Celebrating eyes (closed with joy)
                    Group {
                        let eyeOffsetY = size * 0.08
                        let eyeSpacing = size * 0.14
                        Path { path in
                            let leftStart = CGPoint(x: center.x - eyeSpacing/2 - size * 0.02, y: center.y - eyeOffsetY)
                            let leftEnd = CGPoint(x: center.x - eyeSpacing/2 + size * 0.02, y: center.y - eyeOffsetY)
                            let leftCtrl = CGPoint(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY + size * 0.02)
                            path.move(to: leftStart)
                            path.addQuadCurve(to: leftEnd, control: leftCtrl)
                        }
                        .stroke(Color.black, lineWidth: 2)

                        Path { path in
                            let rightStart = CGPoint(x: center.x + eyeSpacing/2 - size * 0.02, y: center.y - eyeOffsetY)
                            let rightEnd = CGPoint(x: center.x + eyeSpacing/2 + size * 0.02, y: center.y - eyeOffsetY)
                            let rightCtrl = CGPoint(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY + size * 0.02)
                            path.move(to: rightStart)
                            path.addQuadCurve(to: rightEnd, control: rightCtrl)
                        }
                        .stroke(Color.black, lineWidth: 2)
                    }

                    // Big celebration smile
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.22, y: center.y + size * 0.12))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.22, y: center.y + size * 0.12),
                            control: CGPoint(x: center.x, y: center.y + size * 0.26)
                        )
                    }
                    .stroke(Color.black, lineWidth: 3)

                    // Rosy celebration cheeks
                    Group {
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.12, height: size * 0.07)
                            .opacity(0.5)
                            .position(x: center.x - size * 0.22, y: center.y + size * 0.10)

                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.12, height: size * 0.07)
                            .opacity(0.5)
                            .position(x: center.x + size * 0.22, y: center.y + size * 0.10)
                    }

                    // Celebration confetti around head
                    ForEach(0..<6, id: \.self) { index in
                        let positions: [(CGFloat, CGFloat)] = [
                            (-0.38, -0.26), (0.38, -0.26), (-0.32, -0.40), (0.32, -0.40), (-0.28, -0.52), (0.28, -0.52)
                        ]
                        let p = positions[index]
                        let colors: [Color] = [
                            Color(red: 0.831, green: 0.686, blue: 0.216),
                            Color(red: 0.831, green: 0.502, blue: 0.435),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ]

                        Rectangle()
                            .fill(colors[index % colors.count])
                            .frame(width: size * 0.05, height: size * 0.05)
                            .cornerRadius(2)
                            .position(x: center.x + size * p.0, y: center.y + size * p.1)
                            .rotationEffect(.degrees(celebrateAnimation ? 360 : 0))
                            .scaleEffect(celebrateAnimation ? 1.2 : 0.8)
                            .opacity(celebrateAnimation ? 1.0 : 0.6)
                            .animation(
                                .easeInOut(duration: 2)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: celebrateAnimation
                            )
                    }
                }
            }
        }
        .frame(width: 160, height: 160)
        .onAppear {
            celebrateAnimation = true
        }
    }
}
