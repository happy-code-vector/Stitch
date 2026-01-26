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
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)

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

                    // Proud eyes
                    Group {
                        let eyeOffsetY = size * 0.08
                        let eyeSpacing = size * 0.12
                        Circle().fill(Color.black).frame(width: size * 0.04, height: size * 0.04)
                            .position(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                        Circle().fill(Color.black).frame(width: size * 0.04, height: size * 0.04)
                            .position(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)
                    }

                    // Confident eyebrows above each eye
                    Group {
                        let eyeOffsetY = size * 0.08
                        let eyeSpacing = size * 0.12
                        let leftEyeCenter = CGPoint(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                        let rightEyeCenter = CGPoint(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)

                        Path { path in
                            let start = CGPoint(x: leftEyeCenter.x - size * 0.06, y: leftEyeCenter.y - size * 0.07)
                            let end = CGPoint(x: leftEyeCenter.x + size * 0.06, y: leftEyeCenter.y - size * 0.07)
                            let control = CGPoint(x: leftEyeCenter.x, y: leftEyeCenter.y - size * 0.10)
                            path.move(to: start)
                            path.addQuadCurve(to: end, control: control)
                        }
                        .stroke(Color.black, lineWidth: 2)

                        Path { path in
                            let start = CGPoint(x: rightEyeCenter.x - size * 0.06, y: rightEyeCenter.y - size * 0.07)
                            let end = CGPoint(x: rightEyeCenter.x + size * 0.06, y: rightEyeCenter.y - size * 0.07)
                            let control = CGPoint(x: rightEyeCenter.x, y: rightEyeCenter.y - size * 0.10)
                            path.move(to: start)
                            path.addQuadCurve(to: end, control: control)
                        }
                        .stroke(Color.black, lineWidth: 2)
                    }

                    // Proud smile
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.18, y: center.y + size * 0.12))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.18, y: center.y + size * 0.12),
                            control: CGPoint(x: center.x, y: center.y + size * 0.22)
                        )
                    }
                    .stroke(Color.black, lineWidth: 2.5)

                    // Rosy proud cheeks
                    Group {
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.11, height: size * 0.07)
                            .opacity(0.4)
                            .position(x: center.x - size * 0.20, y: center.y + size * 0.10)

                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.11, height: size * 0.07)
                            .opacity(0.4)
                            .position(x: center.x + size * 0.20, y: center.y + size * 0.10)
                    }

                    // Trophy held high (top-right of face)
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.831, green: 0.686, blue: 0.216))
                            .frame(width: size * 0.13, height: size * 0.10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.9, green: 0.8, blue: 0.3))
                                    .frame(width: size * 0.10, height: size * 0.07)
                            )
                        Rectangle()
                            .fill(Color(red: 0.7, green: 0.6, blue: 0.2))
                            .frame(width: size * 0.16, height: size * 0.03)
                        Rectangle()
                            .fill(Color(red: 0.6, green: 0.5, blue: 0.15))
                            .frame(width: size * 0.20, height: size * 0.025)
                    }
                    .position(x: center.x + size * 0.33, y: center.y - size * 0.33)
                    .offset(y: trophyFloat ? -size * 0.03 : size * 0.03)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: trophyFloat)

                    // Sparkles around trophy
                    ForEach(0..<3, id: \.self) { index in
                        let positions: [(CGFloat, CGFloat)] = [(0.22, -0.40), (0.40, -0.28), (0.28, -0.18)]
                        let p = positions[index]
                        Text("✨")
                            .font(.caption)
                            .position(x: center.x + size * p.0, y: center.y + size * p.1)
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
            }
            .frame(width: 160, height: 160)
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
