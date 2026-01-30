import SwiftUI

struct WorkModeView: View {
    @EnvironmentObject var appState: AppState
    @State private var isPaused = false
    @State private var rowCount = 12
    @State private var confidence = 94.0
    @State private var flashlightOn = false
    @State private var batterySaverOn = false
    @State private var sessionStartTime = Date()
    @State private var initialRowCount = 12
    @State private var showDiagnosis = false
    @State private var confidenceTimer: Timer?
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Camera Feed Area - Top 60%
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [
                            Color(red: 0.31, green: 0.31, blue: 0.31),
                            Color(red: 0.44, green: 0.44, blue: 0.44),
                            Color(red: 0.56, green: 0.56, blue: 0.56)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Simulated camera feed texture
                    CameraNoiseView()
                        .opacity(0.2)
                    
                    // Confidence Meter - Very Top
                    VStack {
                        HStack {
                            Text("Confidence")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.white.opacity(0.2))
                                        .frame(height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(confidenceColor)
                                        .frame(width: geometry.size.width * (confidence / 100), height: 8)
                                        .animation(.easeOut(duration: 0.5), value: confidence)
                                }
                            }
                            .frame(height: 8)
                            
                            Text("\(Int(confidence))%")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 48, alignment: .trailing)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.black.opacity(0.4))
                        
                        Spacer()
                    }
                    
                    // Exit Button - Top Left
                    VStack {
                        HStack {
                            Button(action: handleExit) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.black.opacity(0.4))
                                    .clipShape(Circle())
                            }
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    // Yarn Detection Bounding Box
                    YarnDetectionBoxView(isPaused: isPaused)
                    
                    // AR Trust Indicator Line
                    if !isPaused && !batterySaverOn {
                        ARTrustLineView(rowCount: rowCount)
                    }
                    
                    // Row Count Display - Large and prominent
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Current Row")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(rowCount)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rowCount)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.black.opacity(0.6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                                )
                        )
                        .padding(.bottom, 24)
                    }
                    
                    // Pause Overlay
                    if isPaused {
                        Color.black.opacity(0.5)
                            .overlay(
                                VStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 120, height: 120)
                                        .overlay(
                                            Image(systemName: "pause.fill")
                                                .font(.system(size: 48))
                                                .foregroundColor(.white)
                                        )
                                }
                            )
                            .transition(.opacity)
                    }
                    
                    // Battery Saver Overlay
                    if batterySaverOn {
                        Color.black.opacity(0.95)
                            .transition(.opacity)
                    }
                    
                    // Reactive Mascot
                    VStack {
                        HStack {
                            Spacer()
                            ReactiveMascotView(confidence: confidence)
                                .padding(.trailing, 16)
                        }
                        .padding(.top, 80)
                        Spacer()
                    }
                }
                .frame(maxHeight: .infinity)
                .clipped()
                
                // Control Panel - Bottom 40%
                VStack(spacing: 0) {
                    // Top curve
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .frame(height: 24)
                        .offset(y: -12)
                    
                    VStack(spacing: 0) {
                        // Control buttons row
                        HStack {
                            // Flashlight Toggle
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    flashlightOn.toggle()
                                }
                            }) {
                                Image(systemName: flashlightOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(flashlightOn ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 44, height: 44)
                                    .background(flashlightOn ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(flashlightOn ? 0.2 : 0.05), radius: flashlightOn ? 8 : 2, x: 0, y: flashlightOn ? 4 : 1)
                            }
                            
                            // Battery Saver Toggle
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    batterySaverOn.toggle()
                                }
                            }) {
                                Image(systemName: batterySaverOn ? "moon.fill" : "moon")
                                    .font(.system(size: 20))
                                    .foregroundColor(batterySaverOn ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 44, height: 44)
                                    .background(batterySaverOn ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(batterySaverOn ? 0.2 : 0.05), radius: batterySaverOn ? 8 : 2, x: 0, y: batterySaverOn ? 4 : 1)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        // Main Control Area
                        HStack(spacing: 16) {
                            // Manual Decrement
                            Button(action: handleManualDecrement) {
                                Image(systemName: "minus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 64, height: 64)
                                    .background(
                                        Circle()
                                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
                                    )
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rowCount)
                            
                            // Main Pause/Resume Button
                            Button(action: togglePause) {
                                VStack(spacing: 4) {
                                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                        .font(.system(size: 36))
                                        .foregroundColor(.white)
                                        .offset(x: isPaused ? 2 : 0)
                                    
                                    Text(isPaused ? "Resume" : "Pause")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 128, height: 128)
                                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPaused)
                            
                            // Manual Increment
                            Button(action: handleManualIncrement) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 64, height: 64)
                                    .background(
                                        Circle()
                                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
                                    )
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rowCount)
                        }
                        .padding(.vertical, 32)
                        
                        // Status Text
                        Text(isPaused ? "Counting paused. Tap Resume to continue." : "AI is actively counting your rows")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        // Stitch Doctor Button
                        Button(action: {
                            showDiagnosis = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "camera")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Check for Mistakes")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(red: 0.79, green: 0.43, blue: 0.37))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                    .background(Color.white)
                    .offset(y: -12)
                }
            }
        }
        .onAppear {
            startConfidenceSimulation()
        }
        .onDisappear {
            stopConfidenceSimulation()
        }
        .sheet(isPresented: $showDiagnosis) {
            StitchDoctorDiagnosisView()
        }
    }
    
    // MARK: - Helper Methods
    
    private var confidenceColor: Color {
        if confidence >= 90 {
            return Color(red: 0.561, green: 0.659, blue: 0.533)
        } else if confidence >= 75 {
            return Color(red: 0.83, green: 0.69, blue: 0.22)
        } else {
            return Color(red: 0.79, green: 0.43, blue: 0.37)
        }
    }
    
    private func handleManualIncrement() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            rowCount += 1
        }
    }
    
    private func handleManualDecrement() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            rowCount = max(0, rowCount - 1)
        }
    }
    
    private func togglePause() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPaused.toggle()
        }
    }
    
    private func handleExit() {
        let timeSpent = Int(Date().timeIntervalSince(sessionStartTime) / 60) // minutes
        let rowsKnit = rowCount - initialRowCount
        
        appState.updateSessionData(rowsKnit: max(0, rowsKnit), timeSpent: timeSpent)
        appState.navigateTo(.sessionSummary)
    }
    
    private func startConfidenceSimulation() {
        confidenceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !isPaused {
                let variation = Double.random(in: -2...2)
                confidence = min(100, max(85, confidence + variation))
            }
        }
    }
    
    private func stopConfidenceSimulation() {
        confidenceTimer?.invalidate()
        confidenceTimer = nil
    }
}

// MARK: - Supporting Views

struct CameraNoiseView: View {
    var body: some View {
        Canvas { context, size in
            let patternSize: CGFloat = 4
            let cols = Int(size.width / patternSize) + 1
            let rows = Int(size.height / patternSize) + 1
            
            for row in 0..<rows {
                for col in 0..<cols {
                    if (row + col) % 2 == 0 {
                        let rect = CGRect(
                            x: CGFloat(col) * patternSize,
                            y: CGFloat(row) * patternSize,
                            width: patternSize,
                            height: patternSize
                        )
                        context.fill(Path(rect), with: .color(.white.opacity(0.1)))
                    }
                }
            }
        }
    }
}

struct YarnDetectionBoxView: View {
    let isPaused: Bool
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Bounding box
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
                .frame(width: 256, height: 192)
                .scaleEffect(isPaused ? 1.0 : (1.0 + sin(animationOffset) * 0.02))
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animationOffset)
            
            // Corner brackets
            VStack {
                HStack {
                    CornerBracketView(position: .topLeft)
                    Spacer()
                    CornerBracketView(position: .topRight)
                }
                Spacer()
                HStack {
                    CornerBracketView(position: .bottomLeft)
                    Spacer()
                    CornerBracketView(position: .bottomRight)
                }
            }
            .frame(width: 256, height: 192)
            
            // Center crosshair
            VStack {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(width: 24, height: 2)
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(width: 2, height: 24)
                    .offset(y: -13)
            }
            
            // Scanning line
            if !isPaused {
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(width: 240, height: 2)
                    .shadow(color: Color(red: 0.561, green: 0.659, blue: 0.533), radius: 4)
                    .offset(y: animationOffset)
                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: animationOffset)
            }
            
            // Detection label
            VStack {
                Spacer()
                Text(isPaused ? "Paused" : "Detecting yarn...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .offset(y: 32)
            }
        }
        .onAppear {
            if !isPaused {
                animationOffset = -96
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    animationOffset = 96
                }
            }
        }
    }
}

struct CornerBracketView: View {
    enum Position {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    let position: Position
    
    var body: some View {
        Path { path in
            let size: CGFloat = 30
            let thickness: CGFloat = 4
            
            switch position {
            case .topLeft:
                path.move(to: CGPoint(x: 0, y: size))
                path.addLine(to: CGPoint(x: 0, y: thickness))
                path.addLine(to: CGPoint(x: thickness, y: thickness))
                path.addLine(to: CGPoint(x: thickness, y: 0))
                path.addLine(to: CGPoint(x: size, y: 0))
                
            case .topRight:
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: size - thickness, y: 0))
                path.addLine(to: CGPoint(x: size - thickness, y: thickness))
                path.addLine(to: CGPoint(x: size, y: thickness))
                path.addLine(to: CGPoint(x: size, y: size))
                
            case .bottomLeft:
                path.move(to: CGPoint(x: size, y: size))
                path.addLine(to: CGPoint(x: thickness, y: size))
                path.addLine(to: CGPoint(x: thickness, y: size - thickness))
                path.addLine(to: CGPoint(x: 0, y: size - thickness))
                path.addLine(to: CGPoint(x: 0, y: 0))
                
            case .bottomRight:
                path.move(to: CGPoint(x: size, y: 0))
                path.addLine(to: CGPoint(x: size, y: size - thickness))
                path.addLine(to: CGPoint(x: size - thickness, y: size - thickness))
                path.addLine(to: CGPoint(x: size - thickness, y: size))
                path.addLine(to: CGPoint(x: 0, y: size))
            }
        }
        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
        .frame(width: 30, height: 30)
    }
}

struct ARTrustLineView: View {
    let rowCount: Int
    @State private var glowIntensity: Double = 0.5
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            // Glowing curved line
            Path { path in
                path.move(to: CGPoint(x: 0, y: 20))
                path.addQuadCurve(to: CGPoint(x: 200, y: 20), control: CGPoint(x: 100, y: 15))
                path.addQuadCurve(to: CGPoint(x: 400, y: 20), control: CGPoint(x: 300, y: 25))
            }
            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 3)
            .shadow(color: Color(red: 0.561, green: 0.659, blue: 0.533), radius: glowIntensity * 20)
            .opacity(0.5 + glowIntensity * 0.3)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glowIntensity)
            .padding(.horizontal, 32)
            .overlay(
                // Row Count Bubble
                VStack {
                    Text("Row \(rowCount)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.black.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3), lineWidth: 1)
                                )
                        )
                        .offset(y: floatingOffset - 48)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floatingOffset)
                }
            )
            
            Spacer()
                .frame(height: 120)
        }
        .onAppear {
            glowIntensity = 1.2
            floatingOffset = -5
        }
    }
}

struct ReactiveMascotView: View {
    let confidence: Double
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            if confidence >= 90 {
                HappyMascotView()
            } else if confidence >= 75 {
                NeutralMascotView()
            } else {
                ConfusedMascotView()
            }
        }
        .offset(y: isAnimating ? -5 : 0)
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

struct HappyMascotView: View {
    var body: some View {
        ZStack {
            // Body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.49, green: 0.57, blue: 0.46)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
            
            // Highlight
            Ellipse()
                .fill(.white.opacity(0.4))
                .frame(width: 24, height: 16)
                .offset(x: -8, y: -8)
            
            // Happy Eyes
            HStack(spacing: 10) {
                Circle().fill(.black).frame(width: 5, height: 5)
                Circle().fill(.black).frame(width: 5, height: 5)
            }
            .offset(y: -6)
            
            // Smile - closer to eyes
            Path { path in
                path.move(to: CGPoint(x: -8, y: 2))
                path.addQuadCurve(to: CGPoint(x: 8, y: 2), control: CGPoint(x: 0, y: 7))
            }
            .stroke(.black, lineWidth: 2)
            
            // Cheeks - closer to face
            HStack(spacing: 20) {
                Ellipse().fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6)).frame(width: 7, height: 5)
                Ellipse().fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6)).frame(width: 7, height: 5)
            }
            .offset(y: 0)
        }
    }
}

struct NeutralMascotView: View {
    var body: some View {
        ZStack {
            // Body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.49, green: 0.57, blue: 0.46)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
            
            // Highlight
            Ellipse()
                .fill(.white.opacity(0.4))
                .frame(width: 24, height: 16)
                .offset(x: -8, y: -8)
            
            // Neutral Eyes
            HStack(spacing: 10) {
                Circle().fill(.black).frame(width: 5, height: 5)
                Circle().fill(.black).frame(width: 5, height: 5)
            }
            .offset(y: -6)
            
            // Neutral Mouth - closer to eyes
            Rectangle()
                .fill(.black)
                .frame(width: 14, height: 2)
                .cornerRadius(1)
                .offset(y: 3)
        }
    }
}

struct ConfusedMascotView: View {
    @State private var flashlightGlow = false
    
    var body: some View {
        ZStack {
            // Body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.49, green: 0.57, blue: 0.46)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
            
            // Highlight
            Ellipse()
                .fill(.white.opacity(0.4))
                .frame(width: 24, height: 16)
                .offset(x: -8, y: -8)
            
            // Confused Eyes (different sizes)
            HStack(spacing: 10) {
                Circle().fill(.black).frame(width: 4, height: 4)
                Circle().fill(.black).frame(width: 6, height: 6)
            }
            .offset(y: -6)
            
            // Confused Mouth (wavy) - closer to eyes
            Path { path in
                path.move(to: CGPoint(x: -7, y: 3))
                path.addQuadCurve(to: CGPoint(x: 0, y: 5), control: CGPoint(x: -3, y: 5))
                path.addQuadCurve(to: CGPoint(x: 7, y: 3), control: CGPoint(x: 3, y: 5))
            }
            .stroke(.black, lineWidth: 2)
            
            // Flashlight
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.83, green: 0.69, blue: 0.22))
                            .frame(width: 8, height: 20)
                        
                        // Light beam
                        Path { path in
                            path.move(to: CGPoint(x: 4, y: 0))
                            path.addLine(to: CGPoint(x: 16, y: -24))
                            path.addLine(to: CGPoint(x: -8, y: -24))
                            path.closeSubpath()
                        }
                        .fill(Color.yellow.opacity(flashlightGlow ? 0.6 : 0.3))
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: flashlightGlow)
                        .offset(y: -10)
                    }
                    .offset(x: 48, y: -8)
                }
                Spacer()
            }
        }
        .onAppear {
            flashlightGlow = true
        }
    }
}

struct StitchDoctorDiagnosisView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Stitch Doctor")
                    .font(.title)
                    .padding()
                
                Text("Camera-based mistake detection coming soon!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}