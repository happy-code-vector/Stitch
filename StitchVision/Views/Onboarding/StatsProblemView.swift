import SwiftUI

struct StatsProblemView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateStats = false
    
    var body: some View {
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
                    // Empathy Mascot
                    EmpathyMascotView()
                        .scaleEffect(animateStats ? 1.0 : 0.8)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateStats)
                    
                    // Headline
                    Text("You're Not Alone")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateStats)
                    
                    // Subtext
                    Text("Most knitters face the same frustrations:")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 10)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateStats)
                    
                    // Stats Cards
                    VStack(spacing: 16) {
                        StatCardView(
                            icon: "clock.fill",
                            statNumber: "4+ hours",
                            statLabel: "wasted per project",
                            description: "Time spent recounting rows after losing track",
                            delay: 0.4
                        )
                        
                        StatCardView(
                            icon: "exclamationmark.circle.fill",
                            statNumber: "73%",
                            statLabel: "lose track at least once",
                            description: "Every single knitting session, most crafters miscount",
                            delay: 0.5
                        )
                        
                        StatCardView(
                            icon: "face.dashed.fill",
                            statNumber: "1 in 3",
                            statLabel: "projects go unfinished",
                            description: "Counting frustration leads to abandoned projects",
                            delay: 0.6
                        )
                    }
                    
                    // Transition message
                    VStack(spacing: 16) {
                        HStack {
                            Text("But it doesn't have to be this way...")
                                .font(.body)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            Text("💚")
                                .font(.title2)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                        .cornerRadius(12)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: animateStats)
                        
                        // CTA Button
                        Button(action: {
                            appState.navigateTo(.habit)
                        }) {
                            Text("Show Me the Solution")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateStats ? 1.0 : 0.0)
                        .offset(y: animateStats ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: animateStats)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 40)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateStats = true
        }
    }
}

struct StatCardView: View {
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
                .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(statNumber)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                
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
                .stroke(Color(red: 0.831, green: 0.502, blue: 0.435), lineWidth: 3)
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

struct EmpathyMascotView: View {
    @State private var heartBeat = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)

                ZStack {
                    // Main yarn ball body with empathetic expression
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.76, blue: 0.63),
                                    Color(red: 0.561, green: 0.659, blue: 0.533)
                                ],
                                center: .topLeading,
                                startRadius: size * 0.18,
                                endRadius: size * 0.55
                            )
                        )
                        .frame(width: size * 0.75, height: size * 0.75)
                        .position(center)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Yarn texture lines
                    ForEach(0..<6, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 30 * .pi / 180
                            let radius: CGFloat = size * 0.31
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

                    // Concerned/empathetic eyes
                    HStack(spacing: size * 0.09) {
                        Circle().fill(Color.black).frame(width: size * 0.035, height: size * 0.035)
                        Circle().fill(Color.black).frame(width: size * 0.035, height: size * 0.035)
                    }
                    .position(x: center.x, y: center.y - size * 0.06)

                    // Eyebrows directly above each eye
                    Group {
                        // Compute eye centers
                        let eyeOffsetY = size * 0.06
                        let eyeSpacing = size * 0.09
                        let leftEyeCenter = CGPoint(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                        let rightEyeCenter = CGPoint(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)

                        // Left eyebrow above left eye
                        Path { path in
                            let start = CGPoint(x: leftEyeCenter.x - size * 0.05, y: leftEyeCenter.y - size * 0.06)
                            let end = CGPoint(x: leftEyeCenter.x + size * 0.05, y: leftEyeCenter.y - size * 0.06)
                            let control = CGPoint(x: leftEyeCenter.x, y: leftEyeCenter.y - size * 0.09)
                            path.move(to: start)
                            path.addQuadCurve(to: end, control: control)
                        }
                        .stroke(Color.black, lineWidth: 1.5)

                        // Right eyebrow above right eye
                        Path { path in
                            let start = CGPoint(x: rightEyeCenter.x - size * 0.05, y: rightEyeCenter.y - size * 0.06)
                            let end = CGPoint(x: rightEyeCenter.x + size * 0.05, y: rightEyeCenter.y - size * 0.06)
                            let control = CGPoint(x: rightEyeCenter.x, y: rightEyeCenter.y - size * 0.09)
                            path.move(to: start)
                            path.addQuadCurve(to: end, control: control)
                        }
                        .stroke(Color.black, lineWidth: 1.5)
                    }

                    // Empathetic slight frown
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.15, y: center.y + size * 0.12))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.15, y: center.y + size * 0.12),
                            control: CGPoint(x: center.x, y: center.y + size * 0.09)
                        )
                    }
                    .stroke(Color.black, lineWidth: 1.5)

                    // Rosy cheeks
                    HStack(spacing: size * 0.18) {
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.09, height: size * 0.06)
                            .opacity(0.3)
                        Ellipse()
                            .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .frame(width: size * 0.09, height: size * 0.06)
                            .opacity(0.3)
                    }
                    .position(x: center.x, y: center.y + size * 0.03)

                    // Small floating heart
                    Text("💚")
                        .font(.title3)
                        .position(x: center.x, y: center.y - size * 0.46)
                        .scaleEffect(heartBeat ? 1.2 : 1.0)
                        .opacity(heartBeat ? 0.8 : 0.6)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: heartBeat)
                }
            }
        }
        .frame(width: 140, height: 140)
        .onAppear {
            heartBeat = true
        }
    }
}

