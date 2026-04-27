import SwiftUI

struct CameraPermissionsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraManager = CameraPermissionManager.shared
    @State private var animateElements = false
    @State private var showingSettingsAlert = false

    var body: some View {
        ZStack {
            ThemeColors.background
                .ignoresSafeArea()

            // Background image
            Image("camera_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.1)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                // Progress bar (step 6 of 8 = 7/8 filled)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(height: 6)
                        Rectangle()
                            .fill(ThemeColors.primary)
                            .frame(width: animateElements ? geo.size.width * (7.0/8.0) : geo.size.width * (6.0/8.0), height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .animation(.easeOut(duration: 0.8), value: animateElements)
                    }
                }
                .frame(height: 6)

                // Back button
                HStack {
                    BackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 0) {
                        // Mascot
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 128, height: 128)
                                .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 48))
                                .foregroundColor(ThemeColors.primary)
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 32)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animateElements)

                        // Title + subtitle
                        VStack(spacing: 12) {
                            Text("Camera Access")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(ThemeColors.textPrimary)

                            Text("StitchVision needs camera access to count your stitches and detect patterns")
                                .font(.body)
                                .foregroundColor(ThemeColors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 32)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)

                        // Feature list
                        VStack(spacing: 20) {
                            FeatureBullet(icon: "eye", text: "AI-powered stitch counting", delay: 0.4)
                            FeatureBullet(icon: "shield.checkered", text: "Automatic error detection", delay: 0.5)
                            FeatureBullet(icon: "bolt.fill", text: "Real-time progress tracking", delay: 0.6)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 32)

                        // Privacy notice
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.green)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Your Privacy Matters")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(ThemeColors.textPrimary)
                                Text("Images are processed locally on your device. Nothing is stored or shared.")
                                    .font(.system(size: 12))
                                    .foregroundColor(ThemeColors.textSecondary)
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
                    }
                }

                // Action buttons
                VStack(spacing: 8) {
                    Button(action: {
                        handleCameraPermission()
                    }) {
                        Text(cameraManager.isPermissionGranted ? "Continue" : "Enable Camera")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(ThemeColors.primary)
                            .cornerRadius(28)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        appState.navigateTo(.subscription)
                    }) {
                        Text("Maybe Later")
                            .font(.headline)
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.9), value: animateElements)
            }
        }
        .onAppear {
            animateElements = true
            cameraManager.checkPermissionStatus()
        }
        .alert("Camera Access Required", isPresented: $showingSettingsAlert) {
            Button("Open Settings") {
                cameraManager.openAppSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Camera access was previously denied. Please enable it in Settings to use StitchVision's AI features.")
        }
    }

    private func handleCameraPermission() {
        switch cameraManager.permissionStatus {
        case .granted:
            appState.navigateTo(.subscription)
        case .notDetermined:
            cameraManager.requestCameraPermission { granted in
                if granted {
                    appState.navigateTo(.subscription)
                } else {
                    showingSettingsAlert = true
                }
            }
        case .denied:
            showingSettingsAlert = true
        case .restricted:
            showingSettingsAlert = true
        }
    }
}

struct FeatureBullet: View {
    let icon: String
    let text: String
    let delay: Double

    @State private var animate = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(ThemeColors.primary)
                .frame(width: 28)

            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ThemeColors.textPrimary)

            Spacer()
        }
        .opacity(animate ? 1.0 : 0.0)
        .offset(x: animate ? 0 : -30)
        .animation(.easeOut(duration: 0.6).delay(delay), value: animate)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    CameraPermissionsView()
        .environmentObject(AppState())
}
