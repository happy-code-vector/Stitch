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
                            .fill(ThemeColors.primaryGradient)
                            .frame(width: 56, height: 56)
                            .shadow(color: ThemeColors.primary.opacity(0.35), radius: 12, x: 0, y: 6)

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
