import SwiftUI

struct FloatingConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    var body: some View {
        ZStack {
            Color.clear
            ForEach(confettiPieces, id: \.id) { piece in
                ConfettiPieceView(piece: piece)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            generateConfetti()
        }
    }
    
    private func generateConfetti() {
        let screen = UIScreen.main.bounds
        let minX: CGFloat = 0
        let maxX: CGFloat = screen.width
        let minY: CGFloat = 0
        let maxY: CGFloat = screen.height

        confettiPieces = (0..<15).map { _ in
            ConfettiPiece(
                id: UUID(),
                x: Double.random(in: minX...maxX),
                y: Double.random(in: minY...maxY),
                color: [
                    Color(red: 0.8, green: 0.9, blue: 0.8),
                    Color(red: 0.9, green: 0.8, blue: 0.9),
                    Color(red: 0.8, green: 0.8, blue: 0.9),
                    Color(red: 0.9, green: 0.9, blue: 0.8)
                ].randomElement() ?? Color.green,
                size: Double.random(in: 4...8),
                rotation: Double.random(in: 0...360),
                animationDuration: Double.random(in: 8...15)
            )
        }
    }
}

struct ConfettiPiece {
    let id: UUID
    let x: Double
    let y: Double
    let color: Color
    let size: Double
    let rotation: Double
    let animationDuration: Double
}

struct ConfettiPieceView: View {
    let piece: ConfettiPiece
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(piece.color)
            .frame(width: piece.size, height: piece.size)
            .position(x: piece.x, y: isAnimating ? piece.y + 220 : piece.y - 220)
            .rotationEffect(.degrees(isAnimating ? piece.rotation + 360 : piece.rotation))
            .opacity(isAnimating ? 0.3 : 0.7)
            .animation(
                .linear(duration: piece.animationDuration)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    FloatingConfettiView()
}
