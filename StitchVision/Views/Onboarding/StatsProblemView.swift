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
            // Main yarn ball body with empathetic expression
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
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Yarn texture lines
            ForEach(0..<6, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 30 * .pi / 180
                    let radius: CGFloat = 40
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
            
            // Concerned/empathetic eyes
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
            }
            .offset(y: -8)
            
            // Concerned eyebrows
            HStack(spacing: 16) {
                Path { path in
                    path.move(to: CGPoint(x: -3, y: -2))
                    path.addQuadCurve(to: CGPoint(x: 7, y: -1), control: CGPoint(x: 2, y: -4))
                }
                .stroke(Color.black, lineWidth: 1.5)
                
                Path { path in
                    path.move(to: CGPoint(x: -7, y: -1))
                    path.addQuadCurve(to: CGPoint(x: 3, y: -2), control: CGPoint(x: -2, y: -4))
                }
                .stroke(Color.black, lineWidth: 1.5)
            }
            .offset(y: -18)
            
            // Empathetic slight frown
            Path { path in
                path.move(to: CGPoint(x: -12, y: 15))
                path.addQuadCurve(to: CGPoint(x: 12, y: 15), control: CGPoint(x: 0, y: 12))
            }
            .stroke(Color.black, lineWidth: 1.5)
            
            // Rosy cheeks
            HStack(spacing: 24) {
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 12, height: 8)
                    .opacity(0.3)
                
                Ellipse()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 12, height: 8)
                    .opacity(0.3)
            }
            .offset(y: 5)
            
            // Small floating heart
            Text("💚")
                .font(.title3)
                .offset(x: 35, y: -35)
                .scaleEffect(heartBeat ? 1.2 : 1.0)
                .opacity(heartBeat ? 0.8 : 0.6)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: heartBeat)
        }
        .onAppear {
            heartBeat = true
        }
    }
}