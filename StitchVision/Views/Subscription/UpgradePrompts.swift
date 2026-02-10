import SwiftUI

// MARK: - Base Upgrade Modal
struct UpgradeModal<Content: View>: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onUpgrade: () -> Void
    let content: Content
    
    init(
        isOpen: Bool,
        onClose: @escaping () -> Void,
        onUpgrade: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isOpen = isOpen
        self.onClose = onClose
        self.onUpgrade = onUpgrade
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isOpen {
                // Backdrop
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onClose()
                    }
                    .transition(.opacity)
                
                // Modal
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 24) {
                        // Close Button
                        HStack {
                            Spacer()
                            Button(action: onClose) {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "xmark")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // Content
                        content
                            .padding(.horizontal, 24)
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            Button(action: onUpgrade) {
                                Text("Upgrade to Pro")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                            
                            Button(action: onClose) {
                                Text("Maybe Later")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                    .background(Color.white)
                    .customCornerRadius(24, corners: [.topLeft, .topRight])
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: -5)
                    .transition(.move(edge: .bottom))
                }
                .ignoresSafeArea()
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isOpen)
    }
}

// MARK: - 1. Advanced Stitch Doctor Upgrade Prompt
struct StitchDoctorUpgradePrompt: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onUpgrade: () -> Void
    
    var body: some View {
        UpgradeModal(isOpen: isOpen, onClose: onClose, onUpgrade: onUpgrade) {
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                }
                
                // Title
                Text("Want Specific Diagnosis?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                // Description
                Text("Free tier gets generic \"Error detected\" alerts. Upgrade to Pro for precise diagnosis like ")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
                + Text("\"Dropped stitch 3 rows down, stitch #47\"")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                + Text(" with step-by-step fix instructions.")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                
                // Before/After Comparison
                VStack(spacing: 16) {
                    // Free Tier
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Free Tier")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        
                        Text("\"Error detected\"")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    // Pro Tier
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Pro Tier")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        Text("\"Dropped stitch 3 rows down, stitch #47. Use crochet hook to pull up through loops...\"")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .padding(16)
                .background(Color(red: 0.976, green: 0.969, blue: 0.949))
                .cornerRadius(16)
                
                // Time Savings
                Text("Save 10-30 minutes")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                + Text(" per error")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
        }
    }
}

// MARK: - 2. Cloud Sync Upgrade Prompt
struct CloudSyncUpgradePrompt: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onUpgrade: () -> Void
    let projectName: String
    let hoursInvested: Int
    
    var body: some View {
        UpgradeModal(isOpen: isOpen, onClose: onClose, onUpgrade: onUpgrade) {
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                
                // Title
                Text("Protect Your Progress")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                // Description
                Group {
                    Text("Great work on ")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    + Text(projectName)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    + Text("! ")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    + (hoursInvested > 0 ? (
                        Text("You've invested ")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        + Text("\(hoursInvested) hours")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                        + Text(" into this project. ")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    ) : Text(""))
                    + Text("Your project data is saved ")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    + Text("locally only")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    + Text(".")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                .multilineTextAlignment(.center)
                
                // Risk Warning
                VStack(alignment: .leading, spacing: 8) {
                    Text("⚠️ Risk of Data Loss")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Delete the app → Data lost forever")
                        Text("• Get a new phone → Data lost forever")
                        Text("• No backup, no recovery")
                    }
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.2), lineWidth: 2)
                )
                
                // Pro Benefits
                VStack(alignment: .leading, spacing: 8) {
                    Text("✓ Pro Cloud Backup")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Automatic cloud sync across all devices")
                        Text("• Seamless recovery if app deleted")
                        Text("• Project history preserved forever")
                    }
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .cornerRadius(16)
                
                // Peace of Mind
                Text("Never lose your work again")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }
        }
    }
}

// MARK: - 3. Complex Pattern Upgrade Prompt
struct ComplexPatternUpgradePrompt: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onUpgrade: () -> Void
    let patternType: PatternType
    
    enum PatternType: String {
        case cables, lace, colorwork, complex
        
        var label: String {
            switch self {
            case .cables: return "cables"
            case .lace: return "lace"
            case .colorwork: return "colorwork"
            case .complex: return "complex stitches"
            }
        }
    }
    
    var body: some View {
        UpgradeModal(isOpen: isOpen, onClose: onClose, onUpgrade: onUpgrade) {
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                }
                
                // Title
                Text("Complex Pattern Detected")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                // Description
                Text("This pattern includes ")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                + Text(patternType.label)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                + Text(". Free tier is limited to simple row counting only.")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                
                // Feature Comparison
                VStack(spacing: 16) {
                    // Free Tier
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Free Tier")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Simple row counting only")
                            Text("• Stockinette, garter, basic ribbing")
                            Text("• No pattern recognition")
                        }
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    // Pro Tier
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 24, height: 24)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Pro Tier")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Full PDF pattern parsing")
                            Text("• Cable crosses, lace repeats, colorwork")
                            Text("• Stitch pattern diagram display")
                            Text("• Section change alerts")
                        }
                        .font(.caption)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    }
                }
                .padding(16)
                .background(Color(red: 0.976, green: 0.969, blue: 0.949))
                .cornerRadius(16)
                
                // Unlock Message
                Text("Upgrade to Pro to tackle ")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                + Text("advanced patterns")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }
        }
    }
}

// MARK: - 4. Multi-Project Upgrade Prompt
struct MultiProjectUpgradePrompt: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onUpgrade: () -> Void
    let currentProjectName: String
    
    var body: some View {
        UpgradeModal(isOpen: isOpen, onClose: onClose, onUpgrade: onUpgrade) {
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "folder.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                
                // Title
                Text("One Project at a Time")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                // Description
                Text("Free tier supports 1 active project. To start a new project, you'll need to complete or delete ")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                + Text(currentProjectName)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                + Text(".")
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                
                // Delete Warning
                VStack(alignment: .leading, spacing: 8) {
                    Text("⚠️ Deleting = Permanent Loss")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Free tier data is saved locally only. Once deleted, your project is gone forever. ")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    + Text("Pro users have cloud backup to restore deleted projects.")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.2), lineWidth: 2)
                )
                
                // Pro Benefits
                VStack(alignment: .leading, spacing: 8) {
                    Text("✓ Pro Unlimited Projects")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Work on multiple projects simultaneously")
                        Text("• Cloud backup for all projects")
                        Text("• Never delete to make space")
                        Text("• Full project history forever")
                    }
                    .font(.caption)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .cornerRadius(16)
                
                // Upgrade CTA
                Text("Upgrade to Pro for ")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                + Text("unlimited projects + cloud sync")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
            }
        }
    }
}

// MARK: - 5. Generic Pro Feature Gate
struct GenericProGatePrompt: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onUpgrade: () -> Void
    let featureName: String
    let description: String
    
    var body: some View {
        UpgradeModal(isOpen: isOpen, onClose: onClose, onUpgrade: onUpgrade) {
            VStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.831, green: 0.502, blue: 0.435).opacity(0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.831, green: 0.502, blue: 0.435))
                }
                
                // Title
                Text(featureName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    .multilineTextAlignment(.center)
                
                // Description
                Text(description)
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .multilineTextAlignment(.center)
                
                // Pro Badge
                VStack(spacing: 12) {
                    Text("✨ Pro Feature")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Upgrade to unlock unlimited access")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                .cornerRadius(16)
            }
        }
    }
}



#Preview {
    StitchDoctorUpgradePrompt(
        isOpen: true,
        onClose: {},
        onUpgrade: {}
    )
}
