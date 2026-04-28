import SwiftUI

struct DownsellView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    @State private var urgencyPulse = false
    
    var body: some View {
        ZStack {
            // Background
            ThemeColors.background
                .ignoresSafeArea()
            
            // Urgency background elements
            GeometryReader { geo in
                Circle()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                    .frame(width: 128, height: 128)
                    .blur(radius: 30)
                    .position(x: geo.size.width - 80, y: 120)
                    .scaleEffect(urgencyPulse ? 1.3 : 1.0)
                    .opacity(urgencyPulse ? 0.2 : 0.1)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: urgencyPulse)
                
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                    .frame(width: 160, height: 160)
                    .blur(radius: 40)
                    .position(x: 80, y: geo.size.height - 160)
                    .scaleEffect(urgencyPulse ? 1.2 : 1.0)
                    .opacity(urgencyPulse ? 0.15 : 0.1)
                    .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(1), value: urgencyPulse)
            }
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
                            .foregroundColor(ThemeColors.textPrimary)
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.5).delay(0.2), value: animateElements)

                        // Subtext
                        Text("We want you to experience the magic of AI knitting. Get Pro at the annual rate — just \(SubscriptionPricing.yearlyPerMonthDisplay).")
                            .font(.body)
                            .foregroundColor(ThemeColors.textSecondary)
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
                                    Text(SubscriptionPricing.monthlyDisplay)
                                        .font(.title3)
                                        .foregroundColor(ThemeColors.textSecondary)
                                        .strikethrough(true, color: Color(red: 0.831, green: 0.502, blue: 0.435))

                                    Spacer()
                                }

                                // New Price
                                HStack {
                                    Text(SubscriptionPricing.yearlyPerMonthAmount)
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))

                                    Text("/mo")
                                        .font(.title)
                                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))

                                    Spacer()
                                }

                                // Savings callout
                                HStack {
                                    Text("Billed annually — Save 42%")
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
                                    .foregroundColor(ThemeColors.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                VStack(spacing: 8) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("AI Row Counting")
                                            .font(.body)
                                            .foregroundColor(ThemeColors.textPrimary)

                                        Spacer()
                                    }

                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)

                                        Text("Stitch Doctor")
                                            .font(.body)
                                            .foregroundColor(ThemeColors.textPrimary)

                                        Spacer()
                                    }

                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: 8, height: 8)

                                        Text("Unlimited Projects")
                                            .font(.body)
                                            .foregroundColor(ThemeColors.textPrimary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 16)
                            .overlay(
                                Rectangle()
                                    .fill(ThemeColors.background)
                                    .frame(height: 2)
                                    .padding(.horizontal, -24),
                                alignment: .top
                            )
                        }
                        .padding(24)
                        .background(ThemeColors.surface)
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
                                .foregroundColor(ThemeColors.textSecondary)
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

    private let sparkleOffsets: [(CGFloat, CGFloat)] = [(0.25, -0.50), (0.50, -0.25), (0.56, -0.44)]

    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)

                ZStack {
                    yarnBall(size: size, center: center)
                    yarnLines(size: size, center: center)
                    eyes(size: size, center: center)
                    smile(size: size, center: center)
                    discountTag(size: size, center: center)
                    tagHole(size: size, center: center)
                    sparkles(size: size, center: center)
                }
            }
        }
        .frame(width: 140, height: 140)
        .onAppear {
            tagFloat = true
            sparkleAnimation = true
        }
    }

    // MARK: - Sub-views

    private func yarnBall(size: CGFloat, center: CGPoint) -> some View {
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
    }

    private func yarnLines(size: CGFloat, center: CGPoint) -> some View {
        ForEach(0..<6, id: \.self) { index in
            self.yarnLine(index: index, size: size, center: center)
        }
    }

    private func yarnLine(index: Int, size: CGFloat, center: CGPoint) -> some View {
        let angle: Double = Double(index) * 30.0 * .pi / 180.0
        let radius: CGFloat = size * 0.32
        let cosAngle: CGFloat = CGFloat(cos(angle))
        let sinAngle: CGFloat = CGFloat(sin(angle))
        let startX: CGFloat = center.x + cosAngle * radius * 0.3
        let startY: CGFloat = center.y + sinAngle * radius * 0.3
        let endX: CGFloat = center.x + cosAngle * radius * 0.7
        let endY: CGFloat = center.y + sinAngle * radius * 0.7
        let start = CGPoint(x: startX, y: startY)
        let end = CGPoint(x: endX, y: endY)
        return Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
        .opacity(0.6)
    }

    private func eyes(size: CGFloat, center: CGPoint) -> some View {
        let eyeOffsetY = size * 0.08
        let eyeSpacing = size * 0.12
        return Group {
            Circle()
                .fill(Color.black)
                .frame(width: size * 0.04, height: size * 0.04)
                .position(x: center.x - eyeSpacing / 2, y: center.y - eyeOffsetY)
            Circle()
                .fill(Color.black)
                .frame(width: size * 0.04, height: size * 0.04)
                .position(x: center.x + eyeSpacing / 2, y: center.y - eyeOffsetY)
        }
    }

    private func smile(size: CGFloat, center: CGPoint) -> some View {
        Path { path in
            path.move(to: CGPoint(x: center.x - size * 0.18, y: center.y + size * 0.12))
            path.addQuadCurve(
                to: CGPoint(x: center.x + size * 0.18, y: center.y + size * 0.12),
                control: CGPoint(x: center.x, y: center.y + size * 0.22)
            )
        }
        .stroke(Color.black, lineWidth: 2.5)
    }

    private func discountTag(size: CGFloat, center: CGPoint) -> some View {
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
    }

    private func tagHole(size: CGFloat, center: CGPoint) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: size * 0.09, height: size * 0.09)
            .overlay(
                Circle().stroke(Color(red: 0.78, green: 0.46, blue: 0.40), lineWidth: 2)
            )
            .position(x: center.x + size * 0.58, y: center.y - size * 0.47)
            .rotationEffect(.degrees(6))
    }

    private func sparkles(size: CGFloat, center: CGPoint) -> some View {
        ForEach(0..<3, id: \.self) { index in
            let p = sparkleOffsets[index]
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
