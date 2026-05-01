import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraManager = CameraPermissionManager.shared
    @StateObject private var geminiService = GeminiVisionService()
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showPermissionAlert = false
    @State private var showGeminiSettings = false

    var userInitials: String {
        let name = appState.userName ?? "C"
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }
    
    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ThemeColors.primary)
                    }

                    Spacer()

                    Text("Settings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(ThemeColors.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(ThemeColors.surface)
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(ThemeColors.primaryGradient)
                                    .frame(width: 64, height: 64)
                                    .shadow(color: ThemeColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        Text(userInitials)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(appState.userName ?? "Creator")
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(ThemeColors.textPrimary)

                                    HStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                            if appState.isPro {
                                                Image(systemName: "crown.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white)
                                                Text("Pro Plan")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.white)
                                            } else {
                                                Text("Free Plan")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(ThemeColors.primary)
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            appState.isPro
                                            ? LinearGradient(
                                                colors: [ThemeColors.warmGold, ThemeColors.warmGold.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            : LinearGradient(
                                                colors: [ThemeColors.primaryLight],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(12)
                                    }
                                }

                                Spacer()
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(ThemeColors.surface)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)

                        // Upgrade Card - Only show if not Pro
                        if !appState.isPro {
                            Button(action: {
                                appState.navigateTo(.subscription)
                            }) {
                                HStack(spacing: 16) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(ThemeColors.primaryGradient)
                                        .frame(width: 4)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Upgrade to Pro")
                                            .font(.system(size: 18, weight: .bold, design: .rounded))
                                            .foregroundColor(ThemeColors.textPrimary)

                                        Text("Unlimited projects, AI row counting, pattern sync and more")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(ThemeColors.textSecondary)
                                            .multilineTextAlignment(.leading)
                                    }

                                    Spacer()

                                    Text("See plans →")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(ThemeColors.primary)
                                }
                                .padding(20)
                                .background(ThemeColors.surface)
                                .cornerRadius(16)
                                .shadow(color: ThemeColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
                            }
                        }
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PREFERENCES")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ThemeColors.textSecondary)
                                .tracking(1)
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 8) {
                                SettingsItemView(
                                    icon: "bell",
                                    title: "Notifications",
                                    description: "Manage your alerts",
                                    action: {
                                        appState.navigateTo(.notifications)
                                    }
                                )
                                
                                // Camera Permission Status
                                Button(action: {
                                    if cameraManager.isPermissionGranted {
                                        // Already granted, just show info
                                        showPermissionAlert = true
                                    } else if cameraManager.canRequestPermission {
                                        // Request permission
                                        cameraManager.requestCameraPermission { _ in
                                            showPermissionAlert = true
                                        }
                                    } else {
                                        // Need to open settings
                                        showPermissionAlert = true
                                    }
                                }) {
                                    HStack(spacing: 16) {
                                        // Icon
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    cameraManager.isPermissionGranted
                                                    ? ThemeColors.primaryLight
                                                    : ThemeColors.accent.opacity(0.1)
                                                )
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Image(systemName: cameraManager.isPermissionGranted ? "camera.fill" : "camera.fill.badge.ellipsis")
                                                        .font(.system(size: 18, weight: .medium))
                                                        .foregroundColor(
                                                            cameraManager.isPermissionGranted
                                                            ? ThemeColors.primary
                                                            : ThemeColors.accent
                                                        )
                                                )
                                        }
                                        
                                        // Text Content
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Camera Permission")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(ThemeColors.textPrimary)
                                            
                                            Text(cameraManager.isPermissionGranted ? "Granted" : "Not granted")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(
                                                    cameraManager.isPermissionGranted
                                                    ? ThemeColors.primary
                                                    : Color(red: 0.79, green: 0.43, blue: 0.37)
                                                )
                                        }
                                        
                                        Spacer()
                                        
                                        // Status indicator
                                        if cameraManager.isPermissionGranted {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(ThemeColors.primary)
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(ThemeColors.textSecondary)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(ThemeColors.surface)
                                    .cornerRadius(14)
                                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                                }

                                SettingsItemView(
                                    icon: "camera",
                                    title: "Calibrate Camera",
                                    description: "Improve AI accuracy",
                                    action: {
                                        appState.navigateTo(.calibration)
                                    }
                                )
                                
                                SettingsItemView(
                                    icon: "sparkles",
                                    title: "AI Settings",
                                    description: "Manage AI row counting preferences",
                                    action: {
                                        showGeminiSettings = true
                                    }
                                )

                                SettingsItemView(
                                    icon: "questionmark.circle",
                                    title: "Help & Support",
                                    description: "FAQs and contact",
                                    action: {
                                        appState.navigateTo(.help)
                                    }
                                )

                                SettingsItemView(
                                    icon: "star",
                                    title: "Rate StitchVision",
                                    description: "Enjoying the app? Leave a review",
                                    action: {
                                        if let url = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                )
                            }
                        }
                        
                        // Account Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ACCOUNT")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(ThemeColors.textSecondary)
                                .tracking(1)
                                .padding(.horizontal, 8)
                            
                            VStack(spacing: 8) {
                                SettingsItemView(
                                    icon: "person",
                                    title: "Edit Profile",
                                    description: "Update your information",
                                    action: {
                                        appState.navigateTo(.profile)
                                    }
                                )
                                
                                SettingsItemView(
                                    icon: "rectangle.portrait.and.arrow.right",
                                    title: "Log Out",
                                    description: "",
                                    isDestructive: true,
                                    action: {
                                        // Handle logout
                                    }
                                )
                                
                                SettingsItemView(
                                    icon: "arrow.counterclockwise",
                                    title: "Restart Tutorial",
                                    description: "Start tutorial again",
                                    action: {
                                        appState.resetOnboarding()
                                    }
                                )
                            }
                        }
                        
                        // Footer
                        VStack(spacing: 4) {
                            Text("Version 1.0.0")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(ThemeColors.textSecondary)
                            Text("© 2026 StitchVision")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                        .padding(.vertical, 32)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
            }
        }
        .onAppear {
            cameraManager.checkPermissionStatus()
            Task {
                await subscriptionManager.checkSubscriptionStatus()
            }
        }
        .sheet(isPresented: $showGeminiSettings) {
            GeminiSettingsView(geminiService: geminiService)
        }
        .alert("Camera Permission", isPresented: $showPermissionAlert) {
            if cameraManager.isPermissionGranted {
                Button("OK", role: .cancel) {}
            } else {
                Button("Open Settings") {
                    cameraManager.openAppSettings()
                }
                Button("Cancel", role: .cancel) {}
            }
        } message: {
            if cameraManager.isPermissionGranted {
                Text("Camera access is granted. You can use all AI-powered features in Work Mode.")
            } else {
                Text("Camera access is required for AI stitch counting and pattern detection. Please enable it in Settings.")
            }
        }
    }
}

// MARK: - Supporting Views

struct SettingsItemView: View {
    let icon: String
    let title: String
    let description: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(icon: String, title: String, description: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            isDestructive
                            ? ThemeColors.accent.opacity(0.1)
                            : ThemeColors.primaryLight
                        )
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(
                                    isDestructive
                                    ? ThemeColors.accent
                                    : ThemeColors.primary
                                )
                        )
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(
                            isDestructive
                            ? ThemeColors.accent
                            : ThemeColors.textPrimary
                        )

                    if !description.isEmpty {
                        Text(description)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(
                        isDestructive
                        ? ThemeColors.accent.opacity(0.5)
                        : ThemeColors.textSecondary
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(ThemeColors.surface)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: title)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
