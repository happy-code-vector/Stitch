import SwiftUI

struct CameraPermissionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateElements = false
    
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
                    
                    // Camera icon with animation
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                            .frame(width: 120, height: 120)
                            .scaleEffect(animateElements ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animateElements)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .opacity(animateElements ? 1.0 : 0.0)
                            .scaleEffect(animateElements ? 1.0 : 0.5)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.4), value: animateElements)
                    }
                    
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
                            // Request camera permission
                            appState.navigateTo(.calibration)
                        }) {
                            Text("Allow Camera Access")
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