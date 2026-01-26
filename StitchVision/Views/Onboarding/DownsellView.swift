import SwiftUI

struct DownsellView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var urgencyPulse = false
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            // Urgency background elements
            Circle()
                .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                .frame(width: 128, height: 128)
                .blur(radius: 30)
                .position(x: UIScreen.main.bounds.width - 80, y: 120)
                .scaleEffect(urgencyPulse ? 1.3 : 1.0)
                .opacity(urgencyPulse ? 0.2 : 0.1)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: urgencyPulse)
            
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .position(x: 80, y: UIScreen.main.bounds.height - 160)
                .scaleEffect(urgencyPulse ? 1.2 : 1.0)
                .opacity(urgencyPulse ? 0.15 : 0.1)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(1), value: urgencyPulse)
            
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
                        // Mascot with 50% OFF tag
                        ExcitedMascotWithTagView()
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .rotationEffect(.degrees(animateElements ? 0 : -10))
                            .animation(.spring(response: 0.6, dampingFraction: 0.5), value: animateElements)
                        
                        // Headline
                        Text("Wait! Don't Miss Out.")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateElements)
                        
                        // Subtext
                        Text("We want you to experience the magic of AI knitting. Get your first year of Pro for half off.")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : 10)
                            .animation(.easeOut(duration: 0.5).delay(0.3), value: animateElements)
                        
                        // Price Card
                        VStack(spacing: 20) {
                            // Special Offer Badge
                            HStack {
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    
                                    Text("Limited Time")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                .scaleEffect(urgencyPulse ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: urgencyPulse)
                            }
                            .padding(.top, -16)
                            .padding(.trailing, -16)
                            
                            // Pricing
                            VStack(spacing: 12) {
                                // Old Price
                                HStack {
                                    Text("$19.99/mo")
                                        .font(.title3)
                                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                        .strikethrough(true, color: Color(red: 0.831, green: 0.502, blue: 0.435))
                                    
                                    Spacer()
                                }
                                
                                // New Price
                                HStack {
                                    Text("$9.99")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                                    
                                    Text("/mo")
                                        .font(.title)
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                                    
                                    Spacer()
                                }
                                
                                // Savings callout
                                HStack {
                                    Text("Save $120 per year")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    Spacer()
                                }
                            }
                            
                            // Features reminder
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Everything Pro includes:")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                VStack(spacing: 8) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("AI Row Counting")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("Stitch Doctor")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("Unlimited Projects")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 16)
                            .overlay(
                                Rectangle()
                                    .fill(Color(red: 0.976, green: 0.969, blue: 0.949))
                                    .frame(height: 2)
                                    .padding(.horizontal, -24),
                                alignment: .top
                            )
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.831, green: 0.502, blue: 0.435), lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
                        
                        // Primary CTA
                        Button(action: {
                            appState.navigateTo(.permissions)
                        }) {
                            Text("Claim 50% Off Offer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.6), value: animateElements)
                        
                        // Secondary Decline Link
                        Button(action: {
                            appState.navigateTo(.permissions)
                        }) {
                            Text("No thanks, continue with limited Free Plan")
                                .font(.body)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .underline()
                                .multilineTextAlignment(.center)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.5).delay(0.8), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
                }
            }
        }
        .onAppear {
            animateElements = true
            urgencyPulse = true
        }
    }
}

struct ExcitedMascotWithTagView: View {
    @State private var tagFloat = false
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
                                endRadius: size * 0.5
                            )
                        )
                        .frame(width: size * 0.8, height: size * 0.8)
                        .position(center)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Yarn texture lines
                    ForEach(0..<6, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 30 * .pi / 180
                            let radius: CGFloat = size * 0.32
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

                    // Excited eyes
                    Group {
                        let eyeOffsetY = size * 0.08
                        let eyeSpacing = size * 0.12
                        Circle().fill(Color.black).frame(width: size * 0.04, height: size * 0.04)
                            .position(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                        Circle().fill(Color.black).frame(width: size * 0.04, height: size * 0.04)
                            .position(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)
                    }

                    // Big excited smile
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.18, y: center.y + size * 0.12))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.18, y: center.y + size * 0.12),
                            control: CGPoint(x: center.x, y: center.y + size * 0.22)
                        )
                    }
                    .stroke(Color.black, lineWidth: 2.5)

                    // 50% OFF tag (top-right of face)
                    VStack(spacing: 4) {
                        Text("50%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("OFF")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.91, green: 0.61, blue: 0.55),
                                Color(red: 0.831, green: 0.502, blue: 0.435),
                                Color(red: 0.78, green: 0.46, blue: 0.40)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .position(x: center.x + size * 0.35, y: center.y - size * 0.35)
                    .offset(y: tagFloat ? -size * 0.03 : size * 0.03)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: tagFloat)
                    .overlay(
                        // Tag hole
                        Circle()
                            .fill(Color.white)
                            .frame(width: size * 0.09, height: size * 0.09)
                            .overlay(
                                Circle().stroke(Color(red: 0.78, green: 0.46, blue: 0.40), lineWidth: 2)
                            )
                            .position(x: center.x + size * 0.58, y: center.y - size * 0.47)
                            .rotationEffect(.degrees(6))
                    )

                    // Sparkles around tag
                    ForEach(0..<3, id: \.self) { index in
                        let positions: [(CGFloat, CGFloat)] = [(0.25, -0.50), (0.50, -0.25), (0.56, -0.44)]
                        let p = positions[index]
                        Text("✨")
                            .font(.caption)
                            .position(x: center.x + size * p.0, y: center.y + size * p.1)
                            .scaleEffect(sparkleAnimation ? 1.2 : 0.8)
                            .opacity(sparkleAnimation ? 1.0 : 0.6)
                            .animation(
                                .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3),
                                value: sparkleAnimation
                            )
                    }
                }
            }
        }
        .frame(width: 140, height: 140)
        .onAppear {
            tagFloat = true
            sparkleAnimation = true
        }
    }
}
