import SwiftUI

struct CalibrationView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var animateElements = false
    @State private var scanningPosition: CGFloat = -100
    @State private var confidence: Double = 0
    @State private var rowCount = 0
    @State private var showProGate = false
    @State private var isCalibrating = false
    @State private var calibrationComplete = false
    @State private var detectedTurns = 0
    @State private var requiredTurns = 3

    private let opticalFlowDetector = OpticalFlowDetector()
    private let feedbackController = FeedbackController()

    var body: some View {
        ZStack {
            // Black camera background
            Color.black
                .ignoresSafeArea()
            
            // Simulated Camera Feed Background
            SimulatedCameraFeedView()
            
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
                
                // Header
                VStack(spacing: 8) {
                    Text("Let's calibrate your AI")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .offset(y: animateElements ? 0 : -20)
                        .animation(.easeOut(duration: 0.6), value: animateElements)
                    
                    Text("Quick 10-second setup to learn your knitting style")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateElements)
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                Spacer()
                
                // Center Detection Area
                VStack {
                    // Neon Detection Rectangle
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.922, green: 1.0, blue: 0.0), lineWidth: 4)
                        .frame(height: 200)
                        .background(Color.clear)
                        .shadow(color: Color(red: 0.922, green: 1.0, blue: 0.0), radius: 15, x: 0, y: 0)
                        .overlay(
                            // Corner indicators
                            VStack {
                                HStack {
                                    CornerIndicator(corners: [.topLeft])
                                    Spacer()
                                    CornerIndicator(corners: [.topRight])
                                }
                                Spacer()
                                HStack {
                                    CornerIndicator(corners: [.bottomLeft])
                                    Spacer()
                                    CornerIndicator(corners: [.bottomRight])
                                }
                            }
                            .padding(8)
                        )
                        .overlay(
                            // Scanning line animation
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.clear,
                                            Color(red: 0.922, green: 1.0, blue: 0.0).opacity(0.8),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 2)
                                .offset(y: scanningPosition)
                                .onAppear {
                                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                        scanningPosition = 100
                                    }
                                }
                        )
                        .scaleEffect(animateElements ? 1.0 : 0.9)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8).delay(0.3), value: animateElements)
                    
                    // Mascot peeking over bottom edge
                    PeekingMascotView()
                        .offset(y: -20)
                        .scaleEffect(animateElements ? 1.0 : 0.8)
                        .opacity(animateElements ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.6), value: animateElements)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Bottom UI Elements
                VStack(spacing: 16) {
                    // Row count display
                    HStack {
                        Spacer()

                        VStack(spacing: 4) {
                            Text("\(detectedTurns)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("TURNS DETECTED")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.6))
                                .tracking(1)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.6))
                                .background(.ultraThinMaterial)
                        )

                        Spacer()
                    }
                    
                    // Confidence meter
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Confidence")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(Int(confidence))%")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                            }
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 6)
                                .overlay(
                                    GeometryReader { geometry in
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                                        Color(red: 0.66, green: 0.76, blue: 0.63)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * confidence / 100)
                                    }
                                )
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.4))
                                .background(.ultraThinMaterial)
                        )
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    // CTA Button
                    Group {
                        if calibrationComplete {
                            Button(action: {
                                feedbackController.provideFeedback(.calibrationSuccess)
                                StitchAnalytics.calibrationSucceeded(durationSeconds: 30, craftType: appState.selectedCraft ?? "knitting")
                                appState.completeOnboarding()
                            }) {
                                Text("Calibration Complete!")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(red: 0.788, green: 0.427, blue: 0.373))
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 32)
                        } else if isCalibrating {
                            Text("Detecting turns... \(detectedTurns)/\(requiredTurns)")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(25)
                                .padding(.horizontal, 32)
                        } else {
                            Button(action: {
                                isCalibrating = true
                                StitchAnalytics.calibrationStarted(craftType: appState.selectedCraft ?? "knitting")
                                startCalibrationSimulation()
                            }) {
                                Text("Start Calibration")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .cornerRadius(25)
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.horizontal, 32)
                        }
                    }
                    .opacity(animateElements ? 1.0 : 0.0)
                    .offset(y: animateElements ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(1.2), value: animateElements)
                }
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            if !subscriptionManager.isPro {
                showProGate = true
                return
            }

            animateElements = true
        }
        .fullScreenCover(isPresented: $showProGate) {
            ProGateView(onUpgrade: {
                showProGate = false
                appState.completeOnboarding()
            }, onSkip: {
                showProGate = false
                appState.completeOnboarding()
            })
        }
    }

    // MARK: - Calibration Logic

    /// Simulates turn detection with staggered timing.
    /// In production, replace with real OpticalFlowDetector frame processing from camera.
    private func startCalibrationSimulation() {
        // Simulate 3 turns detected over ~10 seconds
        let turnIntervals: [TimeInterval] = [3.0, 3.5, 4.0]

        for (index, interval) in turnIntervals.enumerated() {
            let cumulativeDelay = turnIntervals[0..<index].reduce(0, +) + interval
            DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
                guard isCalibrating && !calibrationComplete else { return }

                detectedTurns += 1
                feedbackController.provideFeedback(.rowCounted)

                withAnimation(.easeOut(duration: 0.3)) {
                    confidence = Double(detectedTurns) / Double(requiredTurns) * 100
                }

                if detectedTurns >= requiredTurns {
                    calibrationComplete = true
                    isCalibrating = false
                }
            }
        }
    }
}

struct SimulatedCameraFeedView: View {
    @State private var noiseOffset: CGFloat = 0
    @State private var lightingIntensity: Double = 0.3
    
    var body: some View {
        ZStack {
            // Base gradient to simulate lighting
            LinearGradient(
                colors: [
                    Color(red: 0.3, green: 0.3, blue: 0.3),
                    Color(red: 0.25, green: 0.25, blue: 0.25),
                    Color(red: 0.35, green: 0.35, blue: 0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Simulated knitting texture in background
            KnittingPatternOverlayView()
                .opacity(0.3)
            
            // Vignette effect
            RadialGradient(
                colors: [Color.clear, Color.clear, Color.black.opacity(0.4)],
                center: .center,
                startRadius: 100,
                endRadius: 300
            )
            
            // Subtle moving light effect
            LinearGradient(
                colors: [Color.white.opacity(0.05), Color.clear, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(lightingIntensity)
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    lightingIntensity = 0.5
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct KnittingPatternOverlayView: View {
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / 20)
            let stitchesPerRow = Int(size.width / 15)
            
            for row in 0..<rows {
                for stitch in 0..<stitchesPerRow {
                    let x = CGFloat(stitch) * 15 + (row % 2 == 0 ? 0 : 7.5)
                    let y = CGFloat(row) * 20
                    
                    // Draw stitch as small oval
                    let stitchRect = CGRect(x: x, y: y, width: 12, height: 8)
                    let stitchPath = Path(ellipseIn: stitchRect)
                    
                    context.fill(stitchPath, with: .color(Color(red: 0.62, green: 0.72, blue: 0.59).opacity(0.4)))
                    
                    // Add connecting lines between stitches
                    if stitch < stitchesPerRow - 1 {
                        let startPoint = CGPoint(x: x + 12, y: y + 4)
                        let endPoint = CGPoint(x: x + 15, y: y + 4)
                        var linePath = Path()
                        linePath.move(to: startPoint)
                        linePath.addLine(to: endPoint)
                        
                        context.stroke(linePath, with: .color(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3)), lineWidth: 1.5)
                    }
                }
            }
        }
    }
}

struct CornerIndicator: View {
    let corners: UIRectCorner
    
    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .stroke(Color(red: 0.922, green: 1.0, blue: 0.0), lineWidth: 4)
            .frame(width: 32, height: 32)
            .clipShape(
                CornerShape(corners: corners)
            )
    }
}

struct CornerShape: Shape {
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if corners.contains(.topLeft) {
            path.move(to: CGPoint(x: 0, y: 16))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 16, y: 0))
        }
        
        if corners.contains(.topRight) {
            path.move(to: CGPoint(x: rect.width - 16, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 16))
        }
        
        if corners.contains(.bottomLeft) {
            path.move(to: CGPoint(x: 0, y: rect.height - 16))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 16, y: rect.height))
        }
        
        if corners.contains(.bottomRight) {
            path.move(to: CGPoint(x: rect.width - 16, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 16))
        }
        
        return path
    }
}

struct PeekingMascotView: View {
    @State private var floatAnimation = false
    @State private var speechBubbleVisible = false
    
    var body: some View {
        ZStack {
            peekingBall
            if speechBubbleVisible {
                speechBubble
            }
        }
        .onAppear {
            floatAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                speechBubbleVisible = true
            }
        }
    }

    // MARK: - Sub-views

    private var peekingBall: some View {
        VStack {
            Spacer()
            ZStack {
                ballEllipse
                PeekingYarnLines()
                peekingEyes
                peekingSmile
                ballHighlight
                ballHands
            }
            .offset(y: floatAnimation ? -2 : 2)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floatAnimation)
        }
        .frame(height: 80)
    }

    private var ballEllipse: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 0.66, green: 0.76, blue: 0.63),
                        Color(red: 0.561, green: 0.659, blue: 0.533)
                    ],
                    center: .topLeading,
                    startRadius: 15,
                    endRadius: 35
                )
            )
            .frame(width: 70, height: 60)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }

    private var peekingEyes: some View {
        HStack(spacing: 10) {
            Circle().fill(Color.black).frame(width: 4, height: 4)
            Circle().fill(Color.black).frame(width: 4, height: 4)
        }
        .offset(y: -5)
    }

    private var peekingSmile: some View {
        GeometryReader { geometry in
            Path { path in
                let centerX = geometry.size.width / 2
                path.move(to: CGPoint(x: centerX - 8, y: 50))
                path.addQuadCurve(to: CGPoint(x: centerX + 8, y: 50), control: CGPoint(x: centerX, y: 54))
            }
            .stroke(Color.black, lineWidth: 2)
        }
    }

    private var ballHighlight: some View {
        Ellipse()
            .fill(Color.white.opacity(0.3))
            .frame(width: 24, height: 16)
            .offset(x: -8, y: -12)
    }

    private var ballHands: some View {
        HStack(spacing: 50) {
            Ellipse()
                .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                .frame(width: 16, height: 12)
                .offset(y: 25)
            Ellipse()
                .fill(Color(red: 0.62, green: 0.72, blue: 0.59))
                .frame(width: 16, height: 12)
                .offset(y: 25)
        }
    }

    private var speechBubble: some View {
        VStack {
            HStack {
                Spacer()
                speechBubbleContent
                    .offset(x: -60, y: -40)
            }
            Spacer()
        }
        .opacity(speechBubbleVisible ? 1.0 : 0.0)
        .scaleEffect(speechBubbleVisible ? 1.0 : 0.8)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: speechBubbleVisible)
    }

    private var speechBubbleContent: some View {
        VStack(spacing: 8) {
            Text("Place your knitting here!")
                .font(.caption)
                .foregroundColor(ThemeColors.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(ThemeColors.surface)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .overlay(speechBubbleTail, alignment: .bottom)
            Spacer()
        }
    }

    private var speechBubbleTail: some View {
        HStack {
            Spacer()
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: -8, y: 8))
                path.addLine(to: CGPoint(x: 8, y: 8))
                path.closeSubpath()
            }
            .fill(ThemeColors.surface)
            .frame(width: 16, height: 8)
            .offset(x: -20, y: 4)
            Spacer()
        }
    }
}
private struct PeekingYarnLines: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<3, id: \.self) { index in
                Path { path in
                    let y = CGFloat(index + 2) * 12
                    let centerX = geometry.size.width / 2
                    path.move(to: CGPoint(x: centerX - 25, y: y))
                    path.addQuadCurve(to: CGPoint(x: centerX + 25, y: y), control: CGPoint(x: centerX, y: y - 2))
                }
                .stroke(Color(red: 0.62, green: 0.72, blue: 0.59), lineWidth: 1.5)
                .opacity(0.6)
            }
        }
    }
}

