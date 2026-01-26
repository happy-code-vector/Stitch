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
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let centerX = geo.size.width / 2
                let centerY = geo.size.height / 2

                FolderView(width: size * 0.43, height: size * 0.29)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .position(x: centerX, y: centerY - size * 0.45)

                MascotBallView(ballSize: size * 0.57)
                    .position(x: centerX, y: centerY - size * 0.12)
            }
        }
        .frame(width: 160, height: 200)
    }
}

private struct FolderView: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
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
                .frame(width: width, height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(red: 0.788, green: 0.635, blue: 0.196), lineWidth: 1.5)
                )

            // FolderTab(width: width, height: height)

            Text("1")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.788, green: 0.635, blue: 0.196))
        }
    }
}

private struct FolderTab: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        let left = -width / 2
        let top = -height / 2
        return Path { path in
            path.move(to: CGPoint(x: left, y: top + height * 0.25))
            path.addLine(to: CGPoint(x: left, y: top + height * 0.05))
            path.addQuadCurve(to: CGPoint(x: left + width * 0.08, y: top), control: CGPoint(x: left, y: top))
            path.addLine(to: CGPoint(x: left + width * 0.33, y: top))
            path.addLine(to: CGPoint(x: left + width * 0.42, y: top + height * 0.25))
            path.closeSubpath()
        }
        .fill(Color(red: 0.831, green: 0.686, blue: 0.216))
        .overlay(
            Path { path in
                path.move(to: CGPoint(x: left, y: top + height * 0.25))
                path.addLine(to: CGPoint(x: left, y: top + height * 0.05))
                path.addQuadCurve(to: CGPoint(x: left + width * 0.08, y: top), control: CGPoint(x: left, y: top))
                path.addLine(to: CGPoint(x: left + width * 0.33, y: top))
                path.addLine(to: CGPoint(x: left + width * 0.42, y: top + height * 0.25))
            }
            .stroke(Color(red: 0.788, green: 0.635, blue: 0.196), lineWidth: 1)
        )
    }
}

private struct MascotBallView: View {
    let ballSize: CGFloat

    var body: some View {
        GeometryReader { geo in
            let size = ballSize
            let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            let eyeOffsetY = size * 0.12
            let eyeSpacing = size * 0.18

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.66, green: 0.76, blue: 0.63),
                                Color(red: 0.561, green: 0.659, blue: 0.533)
                            ],
                            center: .topLeading,
                            startRadius: size * 0.23,
                            endRadius: size * 0.46
                        )
                    )
                    .frame(width: size, height: size)
                    .position(center)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                YarnTextureLines(ballSize: ballSize)

                // Eyes (made larger and better positioned)
                Circle()
                    .fill(Color.black)
                    .frame(width: size * 0.06, height: size * 0.06)
                    .position(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                Circle()
                    .fill(Color.black)
                    .frame(width: size * 0.06, height: size * 0.06)
                    .position(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)

                // Eyebrows positioned above eyes
                Path { path in
                    let leftEyeX = center.x - eyeSpacing/2
                    let leftEyeY = center.y - eyeOffsetY
                    path.move(to: CGPoint(x: leftEyeX - size * 0.03, y: leftEyeY - size * 0.04))
                    path.addQuadCurve(
                        to: CGPoint(x: leftEyeX + size * 0.03, y: leftEyeY - size * 0.04),
                        control: CGPoint(x: leftEyeX, y: leftEyeY - size * 0.06)
                    )
                }
                .stroke(Color.black, lineWidth: 1.5)

                Path { path in
                    let rightEyeX = center.x + eyeSpacing/2
                    let rightEyeY = center.y - eyeOffsetY
                    path.move(to: CGPoint(x: rightEyeX - size * 0.03, y: rightEyeY - size * 0.04))
                    path.addQuadCurve(
                        to: CGPoint(x: rightEyeX + size * 0.03, y: rightEyeY - size * 0.04),
                        control: CGPoint(x: rightEyeX, y: rightEyeY - size * 0.06)
                    )
                }
                .stroke(Color.black, lineWidth: 1.5)

                // Smile
                Path { path in
                    path.move(to: CGPoint(x: center.x - size * 0.15, y: center.y + size * 0.11))
                    path.addQuadCurve(
                        to: CGPoint(x: center.x + size * 0.15, y: center.y + size * 0.11),
                        control: CGPoint(x: center.x, y: center.y + size * 0.16)
                    )
                }
                .stroke(Color.black, lineWidth: 2)

                // Arms holding folder
                Ellipse()
                    .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                    .frame(width: size * 0.16, height: size * 0.11)
                    .position(x: center.x - size * 0.35, y: center.y - size * 0.04)

                Ellipse()
                    .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                    .frame(width: size * 0.16, height: size * 0.11)
                    .position(x: center.x + size * 0.35, y: center.y - size * 0.04)
            }
        }
        .frame(width: ballSize, height: ballSize)
    }
}

private struct YarnTextureLines: View {
    let ballSize: CGFloat

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            
            ForEach(0..<5, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 36 * .pi / 180
                    let radius: CGFloat = ballSize * 0.40
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
