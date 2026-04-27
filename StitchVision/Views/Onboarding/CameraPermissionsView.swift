import SwiftUI

struct CameraPermissionsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraManager = CameraPermissionManager.shared
    @State private var animateElements = false
    @State private var showingSettingsAlert = false

    var body: some View {
        VStack(spacing: 0) {
                // Progress bar (step 6 of 8 = 7/8) + Back button
                HStack(spacing: 0) {
                    Button(action: { appState.goBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .frame(width: 40, height: 40)
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                            Rectangle()
                                .fill(ThemeColors.primary)
                                .frame(width: geo.size.width * (7.0/8.0), height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                                .animation(.easeOut(duration: 0.8), value: animateElements)
                        }
                    }
                    .frame(height: 6)
                    .padding(.horizontal, 16)

                    Color.clear.frame(width: 40)
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)

                ScrollView {
                    VStack(spacing: 0) {
                        // Mascot — white circle with camera icon
                        Image("camera_mascot")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 128, height: 128)
                            .shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
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
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 32)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: animateElements)

                        // Feature list
                        VStack(spacing: 24) {
                            FeatureBullet(icon: "eye", text: "AI-powered stitch counting", delay: 0.4)
                            FeatureBullet(icon: "shield.checkered", text: "Automatic error detection", delay: 0.5)
                            FeatureBullet(icon: "bolt.fill", text: "Real-time progress tracking", delay: 0.6)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 40)

                        // Privacy notice card
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
                                    .lineSpacing(2)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
                    }
                    .padding(.bottom, 40)
                }

                // Action buttons
                VStack(spacing: 0) {
                    Button(action: {
                        handleCameraPermission()
                    }) {
                        Text(cameraManager.isPermissionGranted ? "Continue" : "Enable Camera")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(ThemeColors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 28))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }

                    Button(action: {
                        appState.navigateTo(.subscription)
                    }) {
                        Text("Maybe Later")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
                .opacity(animateElements ? 1.0 : 0.0)
                .offset(y: animateElements ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.9), value: animateElements)
            }
        .background(
            ZStack {
                ThemeColors.background.ignoresSafeArea()
                Image("camera_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.1)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        )
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
