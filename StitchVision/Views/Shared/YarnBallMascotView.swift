import SwiftUI

struct YarnBallMascotView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Main yarn ball body
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.8, green: 0.9, blue: 0.8),
                            Color(red: 0.6, green: 0.8, blue: 0.6)
                        ],
                        center: .topLeading,
                        startRadius: 20,
                        endRadius: 80
                    )
                )
                .frame(width: 120, height: 120)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            // Yarn texture lines
            ForEach(0..<8, id: \.self) { index in
                Path { path in
                    let angle = Double(index) * 45 * .pi / 180
                    let radius: CGFloat = 50
                    let startX = cos(angle) * radius * 0.3
                    let startY = sin(angle) * radius * 0.3
                    let endX = cos(angle) * radius * 0.8
                    let endY = sin(angle) * radius * 0.8
                    
                    path.move(to: CGPoint(x: startX, y: startY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
                .stroke(Color(red: 0.5, green: 0.7, blue: 0.5), lineWidth: 2)
                .opacity(0.6)
            }
            
            // Eyes
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
            }
            .offset(y: -15)
            
            // Smile
            Path { path in
                path.addArc(
                    center: CGPoint(x: 0, y: 5),
                    radius: 15,
                    startAngle: .degrees(30),
                    endAngle: .degrees(150),
                    clockwise: false
                )
            }
            .stroke(Color.black, lineWidth: 2)
            .opacity(0.8)
            
            // Trailing yarn strand
            Path { path in
                path.move(to: CGPoint(x: 60, y: -20))
                path.addQuadCurve(
                    to: CGPoint(x: 80, y: -40),
                    control: CGPoint(x: 75, y: -25)
                )
                path.addQuadCurve(
                    to: CGPoint(x: 90, y: -60),
                    control: CGPoint(x: 85, y: -50)
                )
            }
            .stroke(Color(red: 0.6, green: 0.8, blue: 0.6), lineWidth: 3)
            .rotationEffect(.degrees(isAnimating ? 10 : -10))
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    YarnBallMascotView()
        .padding()
}