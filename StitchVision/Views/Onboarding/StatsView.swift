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
            // Main yarn ball body with celebrating expression
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
            
            // Celebrating eyes (closed with joy)
            HStack(spacing: 12) {
                Path { path in
                    path.move(to: CGPoint(x: -2, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 2, y: 0), control: CGPoint(x: 0, y: 2))
                }
                .stroke(Color.black, lineWidth: 2)
                
                Path { path in
                    path.move(to: CGPoint(x: -2, y: 0))
                    path.addQuadCurve(to: CGPoint(x: 2, y: 0), control: CGPoint(x: 0, y: 2))
                }
                .stroke(Color.black, lineWidth: 2)
            }
            .offset(y: -8)
            
            // Big celebration smile
            Path { path in
                path.move(to: CGPoint(x: -20, y: 15))
                path.addQuadCurve(to: CGPoint(x: 20, y: 15), control: CGPoint(x: 0, y: 30))
            }
            .stroke(Color.black, lineWidth: 3)
            
            // Rosy celebration cheeks
            HStack(spacing: 40) {
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 16, height: 10)
                    .opacity(0.5)
                
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 16, height: 10)
                    .opacity(0.5)
            }
            .offset(y: 8)
            
            // Celebration confetti
            ForEach(0..<6, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [
                    (-60, -40), (60, -40), (-50, -60), (50, -60), (-40, -80), (40, -80)
                ]
                let position = positions[index]
                let colors: [Color] = [
                    Color(red: 0.831, green: 0.686, blue: 0.216),
                    Color(red: 0.831, green: 0.502, blue: 0.435),
                    Color(red: 0.561, green: 0.659, blue: 0.533)
                ]
                
                Rectangle()
                    .fill(colors[index % colors.count])
                    .frame(width: 6, height: 6)
                    .cornerRadius(1)
                    .offset(x: position.0, y: position.1)
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
        .onAppear {
            celebrateAnimation = true
        }
    }
}