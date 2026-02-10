import SwiftUI

struct EnhancedSubscriptionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPlan: PlanType = .proYearly
    @State private var selectedTier: PlanTier = .pro
    @State private var animateElements = false
    
    enum PlanType {
        case proYearly, proMonthly
    }
    
    enum PlanTier {
        case free, pro
    }
    
    let keyDifferentiators = [
        (icon: "lock.fill", name: "Advanced Stitch Doctor", free: "Generic alerts", pro: "Specific diagnosis + fixes", highlight: "Save 10-30 min per error", color: Color(red: 0.831, green: 0.502, blue: 0.435)),
        (icon: "cloud.fill", name: "Cloud Backup", free: "Local storage only", pro: "Auto sync across devices", highlight: "Never lose your work", color: Color(red: 0.561, green: 0.659, blue: 0.533)),
        (icon: "doc.text.fill", name: "Pattern Support", free: "Simple counting", pro: "Full PDF parsing (cables, lace)", highlight: "Unlock advanced patterns", color: Color(red: 0.831, green: 0.502, blue: 0.435))
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
                    .scaleEffect(x: animateElements ? 0.9 : 0.85, y: 1, anchor: .leading)
                    .animation(.easeOut(duration: 0.8), value: animateElements)
                
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 4)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 0)
            .padding(.bottom, 24)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Unlock Full Power")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    // Key Differentiators Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What makes Pro worth it?")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        ForEach(Array(keyDifferentiators.enumerated()), id: \.offset) { index, diff in
                            DifferentiatorCard(
                                icon: diff.icon,
                                name: diff.name,
                                free: diff.free,
                                pro: diff.pro,
                                highlight: diff.highlight,
                                color: diff.color,
                                delay: Double(index) * 0.1 + 0.2
                            )
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)
                    
                    // Tier Toggle
                    HStack(spacing: 4) {
                        Button(action: { selectedTier = .free }) {
                            Text("Free")
                                .font(.headline)
                                .foregroundColor(selectedTier == .free ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTier == .free ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear)
                                .cornerRadius(25)
                        }
                        
                        Button(action: { selectedTier = .pro }) {
                            Text("Pro")
                                .font(.headline)
                                .foregroundColor(selectedTier == .pro ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTier == .pro ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear)
                                .cornerRadius(25)
                        }
                    }
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: animateElements)
                    
                    // Tier Content
                    if selectedTier == .free {
                        FreeTierCard()
                    } else {
                        ProTierCard(selectedPlan: $selectedPlan)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 24)
            }
            
            // CTA Button
            VStack(spacing: 12) {
                Button(action: {
                    appState.navigateTo(.authentication)
                }) {
                    Text(selectedTier == .free ? "Continue with Free" : "Start 7-Day Free Trial")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                
                if selectedTier == .pro {
                    Text("Cancel anytime • No commitment")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                Button(action: {
                    appState.navigateTo(.authentication)
                }) {
                    Text(selectedTier == .free ? "Skip" : "Skip trial")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .underline()
                }
                
                // Footer Links
                HStack(spacing: 8) {
                    Button("Restore Purchases") {
                        // Restore purchases logic
                    }
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    
                    Button("Terms") {
                        // Open Terms
                    }
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    
                    Button("Privacy") {
                        // Open Privacy
                    }
                    .font(.caption2)
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
        .onAppear {
            animateElements = true
        }
    }
}

struct DifferentiatorCard: View {
    let icon: String
    let name: String
    let free: String
    let pro: String
    let highlight: String
    let color: Color
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text("Free: \(free) → Pro: \(pro)")
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                
                HStack(spacing: 4) {
                    Text("✨")
                        .font(.caption2)
                    Text(highlight)
                        .font(.caption2)
                        .foregroundColor(color)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(color.opacity(0.15))
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .cornerRadius(16)
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeOut(duration: 0.5).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct FreeTierCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("$0")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            Text("Free Forever")
                .font(.subheadline)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
            
            VStack(spacing: 8) {
                Text("Try StitchVision")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                Text("Full AI counting for 1 project")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
            .cornerRadius(16)
            
            VStack(spacing: 12) {
                FeatureRow(icon: "checkmark", text: "AI Row Counting (1 project)", isIncluded: true)
                FeatureRow(icon: "xmark", text: "Advanced Stitch Doctor", isIncluded: false)
                FeatureRow(icon: "xmark", text: "Cloud Backup", isIncluded: false)
                FeatureRow(icon: "xmark", text: "Complex Patterns", isIncluded: false)
            }
            
            Text("No credit card required")
                .font(.caption)
                .italic()
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
        }
        .padding(32)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
        .transition(.opacity.combined(with: .scale))
    }
}

struct ProTierCard: View {
    @Binding var selectedPlan: EnhancedSubscriptionView.PlanType
    
    var body: some View {
        VStack(spacing: 16) {
            // Yearly Option
            Button(action: { selectedPlan = .proYearly }) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("Save 50%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                            .cornerRadius(12)
                    }
                    .offset(y: 12)
                    
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .stroke(selectedPlan == .proYearly ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.gray.opacity(0.3), lineWidth: 2)
                                .frame(width: 24, height: 24)
                            
                            if selectedPlan == .proYearly {
                                Circle()
                                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Yearly Pro")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            
                            Text("$6.67/mo")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        Spacer()
                        
                        Text("$79.99/year")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                    .padding(24)
                }
                .background(selectedPlan == .proYearly ? Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1) : Color.gray.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedPlan == .proYearly ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear, lineWidth: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Monthly Option
            Button(action: { selectedPlan = .proMonthly }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .stroke(selectedPlan == .proMonthly ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if selectedPlan == .proMonthly {
                            Circle()
                                .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monthly Pro")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        Text("$12.99/mo")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    Spacer()
                }
                .padding(24)
                .background(selectedPlan == .proMonthly ? Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1) : Color.gray.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedPlan == .proMonthly ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.clear, lineWidth: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Pro Features Summary
            VStack(alignment: .leading, spacing: 12) {
                Text("Everything Pro includes:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                
                VStack(spacing: 8) {
                    ProFeatureRow(icon: "sparkles", text: "Unlimited AI Projects")
                    ProFeatureRow(icon: "lock.fill", text: "Advanced Stitch Doctor")
                    ProFeatureRow(icon: "cloud.fill", text: "Cloud Backup & Sync")
                    ProFeatureRow(icon: "doc.text.fill", text: "Complex Pattern Support")
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
            .cornerRadius(16)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
        .transition(.opacity.combined(with: .scale))
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let isIncluded: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(isIncluded ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.gray.opacity(0.3))
            
            Text(text)
                .font(.caption)
                .foregroundColor(isIncluded ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.6, green: 0.6, blue: 0.6))
        }
    }
}

struct ProFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            
            Text(text)
                .font(.caption)
                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
        }
    }
}

#Preview {
    EnhancedSubscriptionView()
        .environmentObject(AppState())
}
