import SwiftUI

/// Pro badge indicator for locked features
struct ProBadgeView: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "crown.fill")
                .font(.system(size: 10))
            Text("PRO")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            LinearGradient(
                colors: [Color(red: 0.83, green: 0.69, blue: 0.22), Color(red: 0.95, green: 0.77, blue: 0.26)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(6)
    }
}

/// Locked feature overlay
struct ProLockedOverlay: View {
    let onTap: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)

            VStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)

                VStack(spacing: 4) {
                    ProBadgeView()
                    Text("Pro Feature")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                Button(action: onTap) {
                    Text("Unlock")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    ProBadgeView()
}
