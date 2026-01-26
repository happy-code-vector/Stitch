import SwiftUI

struct YarnBallMascotView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)

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
                                startRadius: size * 0.15,
                                endRadius: size * 0.6
                            )
                        )
                        .frame(width: size * 0.75, height: size * 0.75)
                        .position(center)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Yarn texture lines
                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let angle = Double(index) * 45 * .pi / 180
                            let radius: CGFloat = size * 0.31
                            let startX = center.x + cos(angle) * radius * 0.3
                            let startY = center.y + sin(angle) * radius * 0.3
                            let endX = center.x + cos(angle) * radius * 0.8
                            let endY = center.y + sin(angle) * radius * 0.8
                            path.move(to: CGPoint(x: startX, y: startY))
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(Color(red: 0.5, green: 0.7, blue: 0.5), lineWidth: 2)
                        .opacity(0.6)
                    }

                    // Eyes
                    HStack(spacing: size * 0.12) {
                        Circle().fill(Color.black).frame(width: size * 0.05, height: size * 0.05)
                        Circle().fill(Color.black).frame(width: size * 0.05, height: size * 0.05)
                    }
                    .position(x: center.x, y: center.y - size * 0.08)

                    // Smile
                    Path { path in
                        let radius = size * 0.13
                        path.addArc(
                            center: CGPoint(x: center.x, y: center.y + size * 0.02),
                            radius: radius,
                            startAngle: .degrees(30),
                            endAngle: .degrees(150),
                            clockwise: false
                        )
                    }
                    .stroke(Color.black, lineWidth: 2)
                    .opacity(0.8)

                    // Trailing yarn strand
                    Path { path in
                        let start = CGPoint(x: center.x + size * 0.33, y: center.y - size * 0.12)
                        path.move(to: start)
                        path.addQuadCurve(
                            to: CGPoint(x: start.x + size * 0.15, y: start.y - size * 0.15),
                            control: CGPoint(x: start.x + size * 0.1, y: start.y - size * 0.05)
                        )
                        path.addQuadCurve(
                            to: CGPoint(x: start.x + size * 0.25, y: start.y - size * 0.35),
                            control: CGPoint(x: start.x + size * 0.2, y: start.y - size * 0.25)
                        )
                    }
                    .stroke(Color(red: 0.6, green: 0.8, blue: 0.6), lineWidth: 3)
                    .rotationEffect(.degrees(isAnimating ? 10 : -10), anchor: .center)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                }
            }
            .frame(width: 160, height: 160)
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
