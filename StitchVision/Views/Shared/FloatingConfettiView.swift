import SwiftUI

struct FloatingConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    var body: some View {
        ZStack {
            ForEach(confettiPieces, id: \.id) { piece in
                ConfettiPieceView(piece: piece)
            }
        }
        .onAppear {
            generateConfetti()
        }
    }
    
    private func generateConfetti() {
        confettiPieces = (0..<15).map { _ in
            ConfettiPiece(
                id: UUID(),
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: -100...UIScreen.main.bounds.height + 100),
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
            .position(x: piece.x, y: isAnimating ? piece.y + 200 : piece.y - 200)
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