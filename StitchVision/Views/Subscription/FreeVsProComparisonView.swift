import SwiftUI
import StoreKit

struct FreeVsProComparisonView: View {
    @EnvironmentObject var appState: AppState
    let onUpgrade: () -> Void
    let onDismiss: (() -> Void)?
    
    @State private var animateElements = false
    
    let features: [(name: String, free: FeatureStatus, pro: FeatureStatus, freeDetail: String, proDetail: String, icon: String, highlight: Bool)] = [
        ("AI Row Counting", .included, .included, "1 active project", "Unlimited projects", "sparkles", false),
        ("Stitch Doctor", .basic, .advanced, "\"Error detected\" alerts", "Specific diagnosis + fix instructions", "lock.fill", true),
        ("Cloud Backup", .notIncluded, .included, "Local storage only", "Automatic cloud sync across devices", "cloud.fill", true),
        ("Pattern Support", .simple, .complex, "Simple counting only", "Full PDF parsing (cables, lace)", "sparkles", true),
        ("Yarn Stash", .notIncluded, .included, "Not available", "Unlimited stash tracking", "sparkles", false),
        ("Pattern Library", .notIncluded, .included, "Not available", "Save & organize patterns", "sparkles", false)
    ]
    
    enum FeatureStatus {
        case included, notIncluded, basic, advanced, simple, complex
    }
    
    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("Free vs Pro")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ThemeColors.textPrimary)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    Text("See what you unlock with Pro")
                        .font(.body)
                        .foregroundColor(ThemeColors.textSecondary)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -10)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)
                }
                .padding(.top, 32)
                
                // Comparison Table
                VStack(spacing: 0) {
                    // Table Header
                    HStack(spacing: 16) {
                        Text("Feature")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(ThemeColors.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Free")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(ThemeColors.textPrimary)
                            .frame(width: 80)
                        
                        Text("Pro")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(ThemeColors.primary)
                            .frame(width: 80)
                    }
                    .padding(16)
                    .background(ThemeColors.primary.opacity(0.1))
                    
                    // Feature Rows
                    ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                        ComparisonRow(
                            icon: feature.icon,
                            name: feature.name,
                            free: feature.free,
                            pro: feature.pro,
                            freeDetail: feature.freeDetail,
                            proDetail: feature.proDetail,
                            highlight: feature.highlight,
                            delay: Double(index) * 0.1 + 0.3
                        )
                        
                        if index < features.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                
                // Value Highlights
                VStack(alignment: .leading, spacing: 16) {
                    Text("Why Upgrade to Pro?")
                        .font(.headline)
                        .foregroundColor(ThemeColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    ValueHighlight(
                        number: "1",
                        title: "Advanced Stitch Doctor",
                        description: "Get specific diagnoses like \"Dropped stitch 3 rows down, stitch #47\" instead of generic \"Error detected\" alerts. Save 10-30 minutes per error."
                    )
                    
                    ValueHighlight(
                        number: "2",
                        title: "Cloud Backup",
                        description: "Never lose your project data. Free tier data is saved locally only—if you delete the app or get a new phone, it's gone forever."
                    )
                    
                    ValueHighlight(
                        number: "3",
                        title: "Complex Patterns",
                        description: "Unlock cables, lace, and colorwork with full PDF pattern parsing. Free tier is limited to simple stockinette and garter."
                    )
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.8), value: animateElements)
                
                // Pricing Card
                VStack(spacing: 12) {
                    Text(SubscriptionPricing.yearlyPerMonthDisplay)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text("billed annually at \(SubscriptionPricing.yearlyDisplay)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))

                    Text("or \(SubscriptionPricing.monthlyDisplay)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.75))
                    
                    Text("7-Day Free Trial")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.831, green: 0.502, blue: 0.435))
                        .cornerRadius(12)
                        .padding(.top, 8)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(ThemeColors.primary)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                
                // CTA Buttons
                VStack(spacing: 12) {
                    Button(action: onUpgrade) {
                        Text("Start Free Trial")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.788, green: 0.427, blue: 0.373))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }

                    if let dismiss = onDismiss {
                        Button(action: dismiss) {
                            Text("Continue with Free")
                                .font(.subheadline)
                                .foregroundColor(ThemeColors.textSecondary)
                        }

                        Button(action: {
                            Task {
                                try? await AppStore.sync()
                            }
                        }) {
                            Text("Restore Purchases")
                                .font(.caption)
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                        .padding(.top, 8)
                    }
                }
                .opacity(animateElements ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(1.2), value: animateElements)
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        }
        .onAppear {
            animateElements = true
        }
    }
}

struct ComparisonRow: View {
    let icon: String
    let name: String
    let free: FreeVsProComparisonView.FeatureStatus
    let pro: FreeVsProComparisonView.FeatureStatus
    let freeDetail: String
    let proDetail: String
    let highlight: Bool
    let delay: Double
    
    @State private var animate = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Feature Name
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(ThemeColors.primary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.textPrimary)
                    
                    if highlight {
                        Text("★ Key Differentiator")
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Free Tier
            VStack(spacing: 4) {
                StatusIcon(status: free)
                Text(freeDetail)
                    .font(.caption2)
                    .foregroundColor(ThemeColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
            
            // Pro Tier
            VStack(spacing: 4) {
                StatusIcon(status: pro)
                Text(proDetail)
                    .font(.caption2)
                    .foregroundColor(ThemeColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
        }
        .padding(16)
        .background(highlight ? Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.05) : Color.clear)
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -20)
        .animation(.easeOut(duration: 0.5).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

struct StatusIcon: View {
    let status: FreeVsProComparisonView.FeatureStatus
    
    var body: some View {
        Group {
            switch status {
            case .included:
                Image(systemName: "checkmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ThemeColors.primary)
            case .notIncluded:
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.gray.opacity(0.3))
            case .basic:
                Text("Basic")
                    .font(.caption)
                    .foregroundColor(ThemeColors.textSecondary)
            case .advanced:
                Text("Advanced")
                    .font(.caption)
                    .foregroundColor(ThemeColors.primary)
            case .simple:
                Text("Simple")
                    .font(.caption)
                    .foregroundColor(ThemeColors.textSecondary)
            case .complex:
                Text("Complex")
                    .font(.caption)
                    .foregroundColor(ThemeColors.primary)
            }
        }
    }
}

struct ValueHighlight: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.831, green: 0.502, blue: 0.435))
                    .frame(width: 24, height: 24)
                
                Text(number)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(ThemeColors.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(ThemeColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    FreeVsProComparisonView(
        onUpgrade: {},
        onDismiss: {}
    )
    .environmentObject(AppState())
}
