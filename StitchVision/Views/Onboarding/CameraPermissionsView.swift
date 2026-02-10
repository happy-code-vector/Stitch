import SwiftUI

struct CameraPermissionsView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var cameraManager = CameraPermissionManager.shared
    @State private var animateElements = false
    @State private var showingSettingsAlert = false
    
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
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Text("Camera Access")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.1), value: animateElements)
                        
                        Text("StitchVision needs camera access to count your stitches and detect patterns")
                            .font(.body)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .opacity(animateElements ? 1.0 : 0.0)
                            .offset(y: animateElements ? 0 : 10)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    
                    // Yarn Ball Mascot with Camera
                    YarnBallCameraMascotView()
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animateElements)
                    
                    // Benefits
                    VStack(spacing: 16) {
                        BenefitRow(
                            icon: "eye.fill",
                            text: "AI-powered stitch counting"
                        )
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(x: animateElements ? 0 : -30)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: animateElements)
                        
                        BenefitRow(
                            icon: "exclamationmark.triangle.fill",
                            text: "Automatic error detection"
                        )
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(x: animateElements ? 0 : -30)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateElements)
                        
                        BenefitRow(
                            icon: "chart.line.uptrend.xyaxis",
                            text: "Real-time progress tracking"
                        )
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(x: animateElements ? 0 : -30)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                    
                    // Privacy note
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .font(.title3)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            
                            Text("Your Privacy Matters")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        }
                        
                        Text("Images are processed locally on your device. Nothing is stored or shared.")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.8), value: animateElements)
                    
                    Spacer(minLength: 40)
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            handleCameraPermission()
                        }) {
                            Text(cameraManager.isPermissionGranted ? "Continue" : "Allow Camera Access")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.9), value: animateElements)
                        
                        Button(action: {
                            appState.navigateTo(.subscription)
                        }) {
                            Text("Maybe Later")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                                )
                        }
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: animateElements)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.vertical, 40)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
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
    
    // MARK: - Helper Methods
    
    private func handleCameraPermission() {
        switch cameraManager.permissionStatus {
        case .granted:
            // Already granted, proceed to next screen
            appState.navigateTo(.calibration)
            
        case .notDetermined:
            // Request permission
            cameraManager.requestCameraPermission { granted in
                if granted {
                    appState.navigateTo(.calibration)
                } else {
                    // User denied permission
                    showingSettingsAlert = true
                }
            }
            
        case .denied:
            // Show alert to open settings
            showingSettingsAlert = true
            
        case .restricted:
            // Show alert that camera is restricted
            showingSettingsAlert = true
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                )
            
            Text(text)
                .font(.body)
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct YarnBallCameraMascotView: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
                let eyeOffsetY = size * 0.08
                let eyeSpacing = size * 0.12

                ZStack {
                    // Main yarn ball body
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.76, blue: 0.63),
                                    Color(red: 0.561, green: 0.659, blue: 0.533)
                                ],
                                center: .topLeading,
                                startRadius: size * 0.18,
                                endRadius: size * 0.6
                            )
                        )
                        .frame(width: size * 0.8, height: size * 0.8)
                        .position(center)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    // Yarn texture lines
                    ForEach(0..<8, id: \.self) { index in
                        let angle = Double(index) * 45 * .pi / 180
                        YarnCurveLine(center: center, size: size, angle: angle)
                    }

                    // Eyes
                    Circle()
                        .fill(Color.black)
                        .frame(width: size * 0.04, height: size * 0.04)
                        .position(x: center.x - eyeSpacing/2, y: center.y - eyeOffsetY)
                    Circle()
                        .fill(Color.black)
                        .frame(width: size * 0.04, height: size * 0.04)
                        .position(x: center.x + eyeSpacing/2, y: center.y - eyeOffsetY)

                    // Eyebrows positioned above eyes
                    Path { path in
                        let leftEyeX = center.x - eyeSpacing/2
                        let leftEyeY = center.y - eyeOffsetY
                        path.move(to: CGPoint(x: leftEyeX - size * 0.03, y: leftEyeY - size * 0.04))
                        path.addQuadCurve(
                            to: CGPoint(x: leftEyeX + size * 0.03, y: leftEyeY - size * 0.04),
                            control: CGPoint(x: leftEyeX, y: leftEyeY - size * 0.06)
                        )
                    }
                    .stroke(Color.black, lineWidth: 1.5)

                    Path { path in
                        let rightEyeX = center.x + eyeSpacing/2
                        let rightEyeY = center.y - eyeOffsetY
                        path.move(to: CGPoint(x: rightEyeX - size * 0.03, y: rightEyeY - size * 0.04))
                        path.addQuadCurve(
                            to: CGPoint(x: rightEyeX + size * 0.03, y: rightEyeY - size * 0.04),
                            control: CGPoint(x: rightEyeX, y: rightEyeY - size * 0.06)
                        )
                    }
                    .stroke(Color.black, lineWidth: 1.5)

                    // Smile
                    Path { path in
                        path.move(to: CGPoint(x: center.x - size * 0.15, y: center.y + size * 0.11))
                        path.addQuadCurve(
                            to: CGPoint(x: center.x + size * 0.15, y: center.y + size * 0.11),
                            control: CGPoint(x: center.x, y: center.y + size * 0.16)
                        )
                    }
                    .stroke(Color.black, lineWidth: 2)

                    // Camera lens on the ball
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.25, height: size * 0.25)
                        .position(x: center.x, y: center.y + size * 0.25)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.4, green: 0.4, blue: 0.4), lineWidth: 2)
                                .frame(width: size * 0.25, height: size * 0.25)
                                .position(x: center.x, y: center.y + size * 0.25)
                        )
                        .overlay(
                            Circle()
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .frame(width: size * 0.15, height: size * 0.15)
                                .position(x: center.x, y: center.y + size * 0.25)
                        )
                        .overlay(
                            Circle()
                                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
                                .frame(width: size * 0.08, height: size * 0.08)
                                .position(x: center.x, y: center.y + size * 0.25)
                        )
                }
            }
        }
    }
}

private struct YarnCurveLine: View {
    let center: CGPoint
    let size: CGFloat
    let angle: Double

    var body: some View {
        let radius: CGFloat = size * 0.32
        let inner = CGPoint(
            x: center.x + Foundation.cos(angle) * radius * 0.2,
            y: center.y + Foundation.sin(angle) * radius * 0.2
        )
        let outer = CGPoint(
            x: center.x + Foundation.cos(angle) * radius * 0.85,
            y: center.y + Foundation.sin(angle) * radius * 0.85
        )
        let ctrl1 = CGPoint(
            x: center.x + Foundation.cos(angle + .pi/8) * radius * 0.5,
            y: center.y + Foundation.sin(angle + .pi/8) * radius * 0.5
        )
        let ctrl2 = CGPoint(
            x: center.x + Foundation.cos(angle - .pi/8) * radius * 0.7,
            y: center.y + Foundation.sin(angle - .pi/8) * radius * 0.7
        )

        return Path { path in
            path.move(to: inner)
            path.addQuadCurve(to: ctrl1, control: inner)
            path.addQuadCurve(to: outer, control: ctrl2)
        }
        .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.8)
        .opacity(0.6)
    }
}