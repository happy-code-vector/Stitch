import SwiftUI

struct ResultView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Background Sparkles
            BackgroundSparklesView()
            
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
                        // Title
                        Text("Your Crafting Profile")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                        
                        // Mascot with Trophy
                        ProudMascotWithTrophyView()
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animateElements)
                        
                        // Badge Card
                        VStack(spacing: 16) {
                            // Badge icon
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.561, green: 0.659, blue: 0.533),
                                            Color(red: 0.49, green: 0.58, blue: 0.47)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Image(systemName: "sparkles")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                .rotationEffect(.degrees(animateElements ? 0 : -5))
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(2), value: animateElements)
                            
                            // Badge text
                            Text("You are a FOCUSED CREATOR")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .multilineTextAlignment(.center)
                            
                            // Description
                            Text("You love the flow of knitting but hate interruptions like counting. StitchVision was built for you.")
                                .font(.body)
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                        .overlay(
                            // Decorative corner accents
                            VStack {
                                HStack {
                                    Spacer()
                                    Circle()
                                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                                        .frame(width: 80, height: 80)
                                        .offset(x: 40, y: -40)
                                }
                                Spacer()
                                HStack {
                                    Circle()
                                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                                        .frame(width: 80, height: 80)
                                        .offset(x: -40, y: 40)
                                    Spacer()
                                }
                            }
                        )
                        .clipped()
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
                        
                        // Feature List Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Here's what StitchVision will do for you:")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            
                            VStack(spacing: 12) {
                                FeatureItemView(
                                    text: "Count rows automatically while you knit",
                                    delay: 1.1
                                )
                                FeatureItemView(
                                    text: "Detect dropped stitches with Stitch Doctor",
                                    delay: 1.2
                                )
                                FeatureItemView(
                                    text: "Track all your projects in one place",
                                    delay: 1.3
                                )
                                FeatureItemView(
                                    text: "Save 4+ hours per project",
                                    delay: 1.4
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.howItWorks)
                        }) {
                            Text("See How It Works")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.5), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct ProudMascotWithTrophyView: View {
    @State private var trophyFloat = false
    
    var body: some View {
        ZStack {
            // Main yarn ball body with proud expression
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
            
            // Proud, confident eyes
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
            }
            .offset(y: -8)
            
            // Confident eyebrows
            HStack(spacing: 20) {
                Path { path in
                    path.move(to: CGPoint(x: -3, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 7, y: -1), control: CGPoint(x: 2, y: -3))
                }
                .stroke(Color.black, lineWidth: 2)
                
                Path { path in
                    path.move(to: CGPoint(x: -7, y: -1))
                    path.addQuadCurve(to: CGPoint(x: 3, y: -2), control: CGPoint(x: -2, y: -3))
                }
                .stroke(Color.black, lineWidth: 2)
            }
            .offset(y: -20)
            
            // Proud smile
            Path { path in
                path.move(to: CGPoint(x: -16, y: 18))
                path.addQuadCurve(to: CGPoint(x: 16, y: 18), control: CGPoint(x: 0, y: 28))
            }
            .stroke(Color.black, lineWidth: 2.5)
            
            // Rosy proud cheeks
            HStack(spacing: 36) {
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 14, height: 9)
                    .opacity(0.4)
                
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 14, height: 9)
                    .opacity(0.4)
            }
            .offset(y: 8)
            
            // Trophy held high
            VStack(spacing: 4) {
                // Trophy cup
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(red: 0.831, green: 0.686, blue: 0.216))
                    .frame(width: 16, height: 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.9, green: 0.8, blue: 0.3))
                            .frame(width: 12, height: 8)
                    )
                
                // Trophy base
                Rectangle()
                    .fill(Color(red: 0.7, green: 0.6, blue: 0.2))
                    .frame(width: 20, height: 4)
                
                Rectangle()
                    .fill(Color(red: 0.6, green: 0.5, blue: 0.15))
                    .frame(width: 24, height: 3)
            }
            .offset(x: 50, y: -50)
            .offset(y: trophyFloat ? -5 : 5)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: trophyFloat)
            
            // Sparkles around trophy
            ForEach(0..<3, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [(35, -65), (65, -45), (45, -30)]
                let position = positions[index]
                
                Text("✨")
                    .font(.caption)
                    .offset(x: position.0, y: position.1)
                    .scaleEffect(trophyFloat ? 1.2 : 0.8)
                    .opacity(trophyFloat ? 1.0 : 0.6)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: trophyFloat
                    )
            }
        }
        .onAppear {
            trophyFloat = true
        }
    }
}

struct BackgroundSparklesView: View {
    @State private var sparkleAnimation = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                let positions: [(CGFloat, CGFloat)] = [
                    (50, 100), (300, 150), (80, 300), (250, 280),
                    (150, 200), (320, 400), (40, 500), (280, 600)
                ]
                let position = positions[index % positions.count]
                
                Text("✨")
                    .font(.title3)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3))
                    .position(x: position.0, y: position.1)
                    .scaleEffect(sparkleAnimation ? 1.5 : 0.5)
                    .opacity(sparkleAnimation ? 0.8 : 0.2)
                    .animation(
                        .easeInOut(duration: 3)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.4),
                        value: sparkleAnimation
                    )
            }
        }
        .onAppear {
            sparkleAnimation = true
        }
    }
}

struct FeatureItemView: View {
    let text: String
    let delay: Double
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                .frame(width: 8, height: 8)
                .scaleEffect(animate ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.3).delay(delay), value: animate)
            
            Text(text)
                .font(.body)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            Spacer()
        }
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeOut(duration: 0.4).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}