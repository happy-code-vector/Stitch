import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPlan: PlanType = .proYearly
    @State private var animateElements = false
    
    enum PlanType {
        case proYearly, proMonthly
    }
    
    let freeFeatures = [
        "AI Row Counting",
        "1 Active Project",
        "Basic Stitch Doctor"
    ]
    
    let proFeatures = [
        "AI Row Counting",
        "Unlimited Projects",
        "Advanced Stitch Doctor",
        "Unlimited Stash",
        "Pattern Library"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            HStack {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Text("Choose Your Plan")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)
                        
                        Text("Start your knitting journey with AI assistance")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : 10)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    
                    // Plan Cards
                    VStack(spacing: 16) {
                        // Pro Plan Card
                        PlanCard(
                            title: "Pro Plan",
                            price: selectedPlan == .proYearly ? "$99.99/year" : "$9.99/month",
                            features: proFeatures,
                            isRecommended: true,
                            isSelected: true
                        )
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)
                        
                        // Free Plan Card
                        PlanCard(
                            title: "Free Plan",
                            price: "Free",
                            features: freeFeatures,
                            isRecommended: false,
                            isSelected: false
                        )
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    
                    // Plan Toggle
                    VStack(spacing: 12) {
                        Text("Billing Period")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        HStack(spacing: 0) {
                            Button(action: {
                                selectedPlan = .proMonthly
                            }) {
                                Text("Monthly")
                                    .font(.body)
                                    .foregroundColor(selectedPlan == .proMonthly ? .white : Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(selectedPlan == .proMonthly ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear)
                                    .customCornerRadius(25, corners: [.topLeft, .bottomLeft])
                            }
                            
                            Button(action: {
                                selectedPlan = .proYearly
                            }) {
                                HStack {
                                    Text("Yearly")
                                        .font(.body)
                                    
                                    Text("Save 20%")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .foregroundColor(selectedPlan == .proYearly ? .white : Color(red: 0.561, green: 0.659, blue: 0.533))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(selectedPlan == .proYearly ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear)
                                .customCornerRadius(25, corners: [.topRight, .bottomRight])
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                        )
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: animateElements)
                    
                    // CTA Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            appState.navigateTo(.downsell)
                        }) {
                            Text("Start Pro Trial")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            appState.navigateTo(.permissions)
                        }) {
                            Text("Continue with Free")
                                .font(.body)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .underline()
                        }
                    }
                    .padding(.horizontal, 32)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
                }
                .padding(.vertical, 40)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
        }
    }
}

struct PlanCard: View {
    let title: String
    let price: String
    let features: [String]
    let isRecommended: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                if isRecommended {
                    Text("RECOMMENDED")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                        .cornerRadius(12)
                }
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text(price)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }
            
            // Features
            VStack(alignment: .leading, spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.body)
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        
                        Text(feature)
                            .font(.body)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isSelected ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear,
                    lineWidth: 3
                )
        )
        .shadow(color: .black.opacity(isSelected ? 0.1 : 0.05), radius: isSelected ? 12 : 8, x: 0, y: isSelected ? 6 : 2)
    }
}

extension View {
    func customCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(SubscriptionRoundedCorner(radius: radius, corners: corners))
    }
}

struct SubscriptionRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}