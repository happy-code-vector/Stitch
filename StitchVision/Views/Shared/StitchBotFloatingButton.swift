import SwiftUI

struct StitchBotFloatingButton: View {
    let onTap: () -> Void
    @State private var isVisible = false

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: onTap) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.49, green: 0.57, blue: 0.46)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

                        Image(systemName: "sparkles")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .accessibilityLabel("Ask StitchBot")
                .accessibilityHint("Opens AI chat assistant")
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 28)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.5)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGroupedBackground)
            .ignoresSafeArea()
        StitchBotFloatingButton(onTap: {})
    }
}
