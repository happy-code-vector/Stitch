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

            // Top background image area (400px) with gradient overlay — matching HTML exactly
            VStack {
                ZStack {
                    // Craft-themed gradient mimicking the yarn shelf photo
                    LinearGradient(
                        colors: [
                            Color(red: 0.35, green: 0.45, blue: 0.30),
                            Color(red: 0.45, green: 0.55, blue: 0.38),
                            Color(red: 0.55, green: 0.62, blue: 0.48),
                            Color(red: 0.65, green: 0.72, blue: 0.58),
                            Color.white.opacity(0.2),
                            Color.white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 400)

                    // Decorative yarn ball shapes
                    HStack(spacing: 20) {
                        Circle().fill(Color(red: 0.91, green: 0.478, blue: 0.365).opacity(0.3)).frame(width: 50, height: 50).offset(y: 20)
                        Circle().fill(Color(red: 0.96, green: 0.75, blue: 0.15).opacity(0.25)).frame(width: 70, height: 70).offset(y: -30)
                        Circle().fill(ThemeColors.primary.opacity(0.3)).frame(width: 55, height: 55).offset(y: 10)
                        Circle().fill(Color(red: 0.93, green: 0.43, blue: 0.55).opacity(0.2)).frame(width: 45, height: 45).offset(y: -15)
                        Circle().fill(Color(red: 0.55, green: 0.75, blue: 0.90).opacity(0.25)).frame(width: 60, height: 60).offset(y: 25)
                    }

                    // Dark overlay at top (matching from-black/40)
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.4),
                            Color.white.opacity(0.2),
                            Color.white.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                Spacer()
            }

            // Main content
            VStack(spacing: 0) {
                // Close button — top-right X on dark background
                HStack {
                    Spacer()
                    Button(action: {
                        appState.navigateTo(.permissions)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.1))
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 24)
                    .padding(.top, 60)
                }

                ScrollView {
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
                        .padding(.top, 20)
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
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(ThemeColors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 28))
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
