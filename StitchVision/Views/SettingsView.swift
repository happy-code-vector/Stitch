import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraManager = CameraPermissionManager.shared
    @State private var isPro = false
    @State private var showPermissionAlert = false
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.navigateTo(.dashboard)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    // Spacer for centering
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                // Avatar
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.561, green: 0.659, blue: 0.533),
                                                Color(red: 0.49, green: 0.57, blue: 0.46)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Text("👋")
                                            .font(.title)
                                    )
                                
                                // User Info
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Creator")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    
                                    HStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                            if isPro {
                                                Image(systemName: "crown.fill")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.white)
                                                Text("Pro Plan")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.white)
                                            } else {
                                                Text("Free Plan")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            isPro 
                                            ? LinearGradient(
                                                colors: [
                                                    Color(red: 0.83, green: 0.69, blue: 0.22),
                                                    Color(red: 1.0, green: 0.84, blue: 0.0)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ).opacity(1.0)
                                            : LinearGradient(
                                                colors: [Color.gray.opacity(0.2)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ).opacity(1.0)
                                        )
                                        .cornerRadius(12)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        
                        // Upgrade Card - Only show if not Pro
                        if !isPro {
                            VStack(spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: "crown")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                    Text("Upgrade Today")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                
                                VStack(spacing: 8) {
                                    Text("Unlock Unlimited Projects")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Get AI row counting, pattern sync, and more")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }
                                
                                Button(action: {
                                    appState.navigateTo(.subscription)
                                }) {
                                    Text("Get Pro")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(red: 0.83, green: 0.69, blue: 0.22))
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color.white)
                                        .cornerRadius(25)
                                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                }
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPro)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 24)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.79, green: 0.43, blue: 0.37)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                            .overlay(
                                // Decorative circles
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 128, height: 128)
                                        .offset(x: 120, y: -60)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 96, height: 96)
                                        .offset(x: -120, y: 60)
                                }
                                .clipped()
                            )
                        }
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PREFERENCES")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
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
                                        Circle()
                                            .fill(
                                                cameraManager.isPermissionGranted
                                                ? Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1)
                                                : Color(red: 0.79, green: 0.43, blue: 0.37).opacity(0.1)
                                            )
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Image(systemName: cameraManager.isPermissionGranted ? "camera.fill" : "camera.fill.badge.ellipsis")
                                                    .font(.system(size: 18, weight: .medium))
                                                    .foregroundColor(
                                                        cameraManager.isPermissionGranted
                                                        ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                                        : Color(red: 0.79, green: 0.43, blue: 0.37)
                                                    )
                                            )
                                        
                                        // Text Content
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Camera Permission")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                            
                                            Text(cameraManager.isPermissionGranted ? "Granted" : "Not granted")
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundColor(
                                                    cameraManager.isPermissionGranted
                                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                                    : Color(red: 0.79, green: 0.43, blue: 0.37)
                                                )
                                        }
                                        
                                        Spacer()
                                        
                                        // Status indicator
                                        if cameraManager.isPermissionGranted {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                        } else {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
                                    icon: "questionmark.circle",
                                    title: "Help & Support",
                                    description: "FAQs and contact",
                                    action: {
                                        appState.navigateTo(.help)
                                    }
                                )
                            }
                        }
                        
                        // Account Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ACCOUNT")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
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
                                    title: "Reset Onboarding",
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
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            Text("© 2024 StitchVision")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
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
                // Icon
                Circle()
                    .fill(
                        isDestructive 
                        ? Color(red: 0.79, green: 0.43, blue: 0.37).opacity(0.1)
                        : Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1)
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(
                                isDestructive 
                                ? Color(red: 0.79, green: 0.43, blue: 0.37)
                                : Color(red: 0.561, green: 0.659, blue: 0.533)
                            )
                    )
                
                // Text Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(
                            isDestructive 
                            ? Color(red: 0.79, green: 0.43, blue: 0.37)
                            : Color(red: 0.173, green: 0.173, blue: 0.173)
                        )
                    
                    if !description.isEmpty {
                        Text(description)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(
                        isDestructive 
                        ? Color(red: 0.79, green: 0.43, blue: 0.37).opacity(0.5)
                        : Color(red: 0.6, green: 0.6, blue: 0.6)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: title)
    }
}