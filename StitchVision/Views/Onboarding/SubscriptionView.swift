import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPlan: PlanType = .annual
    @State private var animateElements = false

    enum PlanType {
        case annual, monthly
    }

    let features = [
        "Unlimited AI Vision Scanning",
        "Access to 500+ Premium Patterns",
        "Exclusive Community Masterclasses"
    ]

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            // Background image
            VStack {
                Image("paywall_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 400)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.4),
                                Color.white.opacity(0.2),
                                Color.white.opacity(0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Spacer()
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Progress bar (step 7 of 8)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 6)
                        Rectangle()
                            .fill(ThemeColors.primary)
                            .frame(width: animateElements ? geo.size.width * (7.0/8.0) : 0, height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .animation(.easeOut(duration: 0.8), value: animateElements)
                    }
                }
                .frame(height: 6)

                // Close button + Back button
                HStack {
                    BackButton()
                    Spacer()
                    Button(action: {
                        appState.navigateTo(.permissions)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // FOMO badge
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 12))
                            Text("LIMITED: JOIN 50,000+ MAKERS TODAY")
                                .font(.system(size: 12, weight: .bold))
                        }
                        .foregroundColor(Color(red: 0.71, green: 0.33, blue: 0.14))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color(red: 1.0, green: 0.925, blue: 0.863))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 1.0, green: 0.871, blue: 0.773), lineWidth: 1)
                        )
                        .padding(.top, 16)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)

                        // Headline
                        VStack(spacing: 8) {
                            Text("Master Every Stitch\nwith Premium")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(ThemeColors.textPrimary)
                                .multilineTextAlignment(.center)

                            Text("Stop recounting. Start creating.")
                                .font(.body)
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 24)
                        .padding(.bottom, 28)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)

                        // Features list
                        VStack(spacing: 16) {
                            ForEach(features, id: \.self) { feature in
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.929, green: 0.957, blue: 0.918))
                                            .frame(width: 24, height: 24)
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(red: 0.22, green: 0.75, blue: 0.39))
                                    }

                                    Text(feature)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(ThemeColors.textPrimary)

                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 28)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)

                        // Annual plan card (recommended)
                        ZStack(alignment: .topTrailing) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedPlan = .annual
                                }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Annual Plan")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(ThemeColors.textPrimary)
                                        Text("$4.99/mo (billed annually)")
                                            .font(.system(size: 14))
                                            .foregroundColor(ThemeColors.textSecondary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("$59.99")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(ThemeColors.textPrimary)
                                        Text("SAVE 60%")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(red: 0.133, green: 0.302, blue: 0.224))
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color(red: 0.929, green: 0.957, blue: 0.918))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(selectedPlan == .annual ? ThemeColors.primary : ThemeColors.primary.opacity(0.2), lineWidth: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Text("BEST VALUE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(ThemeColors.primary)
                                .clipShape(Capsule())
                                .offset(x: -12, y: -10)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)

                        // Monthly plan card
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedPlan = .monthly
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Monthly Plan")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(ThemeColors.textPrimary)
                                    Text("Cancel anytime")
                                        .font(.system(size: 14))
                                        .foregroundColor(ThemeColors.textSecondary)
                                }
                                Spacer()
                                Text("$12.99")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(ThemeColors.textPrimary)
                            }
                            .padding(20)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(selectedPlan == .monthly ? ThemeColors.primary : Color.gray.opacity(0.15), lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 24)
                    }
                }

                // Footer
                VStack(spacing: 12) {
                    Button(action: {
                        appState.navigateTo(.enhancedSubscription)
                    }) {
                        Text("Start 7-Day Free Trial")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(ThemeColors.primary)
                            .cornerRadius(28)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }

                    Text("Payment will be charged to your iTunes account. Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.")
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    HStack(spacing: 24) {
                        Button("Terms of Service") { }
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color.gray.opacity(0.4))
                        Button("Privacy Policy") { }
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color.gray.opacity(0.4))
                        Button("Restore") {
                            Task { try? await AppStore.sync() }
                        }
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color.gray.opacity(0.4))
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 20)
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 1),
                    alignment: .top
                )
            }
        }
        .onAppear {
            animateElements = true
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(AppState())
}
