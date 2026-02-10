import SwiftUI

struct StitchDoctorDiagnosisView: View {
    let isOpen: Bool
    let onClose: () -> Void
    let onSaveToNotes: (() -> Void)?
    let diagnosisText: String?
    
    @State private var animateElements = false
    
    var body: some View {
        ZStack {
            if isOpen {
                // Blurred Glassmorphism Background
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .blur(radius: 20)
                    .onTapGesture {
                        onClose()
                    }
                    .transition(.opacity)
                
                // Central Floating Card
                VStack(spacing: 24) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .padding(8)
                        }
                    }
                    
                    // Stethoscope Icon
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.788, green: 0.427, blue: 0.373).opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "stethoscope")
                            .font(.system(size: 40))
                            .foregroundColor(Color(red: 0.788, green: 0.427, blue: 0.373))
                    }
                    .scaleEffect(animateElements ? 1.0 : 0.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: animateElements)
                    
                    // Heading
                    Text("Diagnosis Complete")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 10)
                        .animation(.easeOut(duration: 0.4).delay(0.4), value: animateElements)
                    
                    // Body Text - AI Diagnosis
                    Text(diagnosisText ?? "It looks like you dropped a stitch 3 rows down. You can fix this by using a crochet hook to pull the loop back up.")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : 10)
                        .animation(.easeOut(duration: 0.4).delay(0.5), value: animateElements)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        // Secondary Button - Save to Notes
                        if let saveAction = onSaveToNotes {
                            Button(action: saveAction) {
                                Text("Save to Notes")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 2)
                                    )
                            }
                        }
                        
                        // Primary Button - Got it
                        Button(action: onClose) {
                            Text("Got it")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 10)
                    .animation(.easeOut(duration: 0.4).delay(0.6), value: animateElements)
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 24)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
                .opacity(animateElements ? 1.0 : 0.0)
                .scaleEffect(animateElements ? 1.0 : 0.9)
                .offset(y: animateElements ? 0 : 20)
                .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(0.1), value: animateElements)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isOpen)
        .onChange(of: isOpen) { newValue in
            if newValue {
                animateElements = true
            } else {
                animateElements = false
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.976, green: 0.969, blue: 0.949)
            .ignoresSafeArea()
        
        StitchDoctorDiagnosisView(
            isOpen: true,
            onClose: {},
            onSaveToNotes: {},
            diagnosisText: nil
        )
    }
}
