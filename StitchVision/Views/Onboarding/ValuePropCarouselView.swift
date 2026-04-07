import SwiftUI

struct ValuePropCarouselView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0

    private let pages: [ValuePropPage] = [
        ValuePropPage(
            imageName: "onboarding-value-1",
            icon: "checkmark.circle.fill",
            title: "Never Lose Your Place",
            subtitle: "AI-powered row counter tracks your progress automatically",
            gradient: [Color(red: 0.561, green: 0.659, blue: 0.533), Color(red: 0.49, green: 0.57, blue: 0.46)]
        ),
        ValuePropPage(
            imageName: "onboarding-value-2",
            icon: "eye.fill",
            title: "AI Stitch Doctor",
            subtitle: "Catch mistakes before they happen with real-time error detection",
            gradient: [Color(red: 0.949, green: 0.631, blue: 0.286), Color(red: 0.89, green: 0.55, blue: 0.22)]
        ),
        ValuePropPage(
            imageName: "onboarding-value-3",
            icon: "square.grid.2x2.fill",
            title: "80+ Free Patterns",
            subtitle: "Beginner to advanced patterns included with your download",
            gradient: [Color(red: 0.4, green: 0.6, blue: 0.8), Color(red: 0.35, green: 0.55, blue: 0.75)]
        )
    ]

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: pages[currentPage].gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Back button (top-left, visible on all pages)
                HStack {
                    Button(action: { appState.goBack() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        ValuePropPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                Spacer()

                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 40)

                // Continue button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Move to personalization
                        appState.navigateTo(.craft)
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundColor(pages[currentPage].gradient[0])
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(false)
    }
}

struct ValuePropPage {
    let imageName: String
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
}

struct ValuePropPageView: View {
    let page: ValuePropPage

    var body: some View {
        VStack(spacing: 24) {
            // Placeholder for lifestyle photo
            // Replace with actual image: Image(page.imageName)
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 280, height: 380)

                VStack(spacing: 16) {
                    Image(systemName: page.icon)
                        .font(.system(size: 64))
                        .foregroundColor(.white)

                    Text("📷")
                        .font(.system(size: 48))
                        .opacity(0.6)

                    Text("Lifestyle Photo")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.bottom, 20)

            // Text content
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ValuePropCarouselView()
        .environmentObject(AppState())
}
