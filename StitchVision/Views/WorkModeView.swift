import SwiftUI
import AVFoundation
import Speech

// Camera delegate wrapper class
class WorkModeCameraDelegate: NSObject, CameraManagerDelegate {
    var onFrameReceived: ((CVPixelBuffer) -> Void)?
    var onError: ((Error) -> Void)?
    
    func cameraManager(_ manager: CameraManager, didOutput sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        onFrameReceived?(pixelBuffer)
    }
    
    func cameraManager(_ manager: CameraManager, didEncounterError error: Error) {
        onError?(error)
    }
}

struct WorkModeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var projectStore: ProjectStore
    @ObservedObject private var cameraPermissionManager = CameraPermissionManager.shared
    @StateObject private var cameraManager = CameraManager()
    @StateObject private var rowCountingService = RowCountingService()
    @StateObject private var voiceCommandManager = VoiceCommandManager()
    @StateObject private var feedbackController = FeedbackController()
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared
    @State private var cameraDelegate = WorkModeCameraDelegate()
    
    @State private var isPaused = false
    @State private var sessionStartTime = Date()
    @State private var initialRowCount = 0
    @State private var showDiagnosis = false
    @State private var isDiagnosing = false
    @State private var diagnosisResult: String?
    @State private var latestFrame: CVPixelBuffer?
    @State private var showPermissionAlert = false
    @State private var showSettings = false
    @State private var showApiKeyAlert = false
    @State private var showVoicePermissionAlert = false
    @State private var showNoProjectAlert = false
    @State private var selectedPattern: KnittingPattern?
    @State private var showPatternLibrary = false
    @State private var showPaywall = false
    @State private var proFeatureRequested: String?

    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Camera Feed Area - Top 60%
                ZStack {
                    // Real camera preview
                    if let previewLayer = cameraManager.previewLayer {
                        CameraPreviewView(previewLayer: previewLayer)
                    } else {
                        // Fallback gradient while camera loads
                        LinearGradient(
                            colors: [
                                Color(red: 0.31, green: 0.31, blue: 0.31),
                                Color(red: 0.44, green: 0.44, blue: 0.44),
                                Color(red: 0.56, green: 0.56, blue: 0.56)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                    
                    // Status Bar - Very Top
                    VStack {
                        HStack {
                            Text(rowCountingService.isCounting ? "Detecting..." : "Ready")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)

                            Spacer()

                            // Voice Command Indicator
                            Button(action: {
                                if voiceCommandManager.isListening {
                                    voiceCommandManager.stopListening()
                                } else {
                                    voiceCommandManager.startListening()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: voiceCommandManager.isListening ? "mic.fill" : "mic.slash")
                                        .font(.system(size: 14))
                                    Text(voiceCommandManager.isListening ? "Listening" : "Voice Off")
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(voiceCommandManager.isListening ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color.black.opacity(0.4))
                                .cornerRadius(16)
                            }
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

                    // Pattern thumbnail (if selected)
                    if let pattern = selectedPattern {
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: { showPatternLibrary = true }) {
                                    PatternProgressOverlay(
                                        pattern: pattern,
                                        currentRowCount: rowCountingService.rowCount
                                    )
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.3), radius: 4)
                                }
                                .padding(.trailing, 16)
                                .padding(.top, 120)
                                Spacer()
                            }
                            Spacer()
                        }
                    }

                    // Row Count Display - Large and prominent
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Current Row")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(rowCountingService.rowCount)")
                                .font(.system(size: 72, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rowCountingService.rowCount)
                            
                            if rowCountingService.lastCountTime != nil {
                                Text("Row counted \(timeAgo(rowCountingService.lastCountTime!))")
                                    .font(.system(size: 10, weight: .regular))
                                    .foregroundColor(.white.opacity(0.6))
                            }
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
                                    cameraManager.toggleTorch()
                                }
                            }) {
                                Image(systemName: cameraManager.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(cameraManager.isTorchOn ? .white : Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 44, height: 44)
                                    .background(cameraManager.isTorchOn ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(cameraManager.isTorchOn ? 0.2 : 0.05), radius: cameraManager.isTorchOn ? 8 : 2, x: 0, y: cameraManager.isTorchOn ? 4 : 1)
                            }
                            
                            // Settings Button - placeholder
                            Button(action: {
                                // TODO: Add settings view for counting preferences
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 44, height: 44)
                                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }

                            // Pattern Button
                            Button(action: { showPatternLibrary = true }) {
                                Image(systemName: selectedPattern != nil ? "photo.fill" : "photo")
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedPattern != nil ? Color(red: 0.561, green: 0.659, blue: 0.533) : Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 44, height: 44)
                                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        
                        // Main Control Area
                        HStack(spacing: 16) {
                            // Manual Decrement
                            Button(action: {
                                rowCountingService.manualDecrement()
                            }) {
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
                            
                            // Manual Increment
                            Button(action: {
                                rowCountingService.manualIncrement()
                            }) {
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
                        }
                        .padding(.vertical, 32)
                        
                        // Status Text
                        Text(isPaused ? "Counting paused. Tap Resume to continue." : rowCountingService.isCounting ? "Detecting rows..." : "Ready to count")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        // Stitch Doctor Button (Pro Feature)
                        Button(action: {
                            if subscriptionManager.canUseAICoach {
                                runStitchDoctor()
                            } else {
                                proFeatureRequested = "AI Coach"
                                showPaywall = true
                            }
                        }) {
                            HStack(spacing: 8) {
                                if isDiagnosing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "camera")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                Text(isDiagnosing ? "Analyzing..." : "Check for Mistakes")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(subscriptionManager.canUseAICoach ? Color(red: 0.79, green: 0.43, blue: 0.37) : Color.gray)
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
            // Require an active project before starting Work Mode
            guard projectStore.getActiveProject() != nil else {
                showNoProjectAlert = true
                return
            }
            cameraPermissionManager.checkPermissionStatus()
            if cameraPermissionManager.isPermissionGranted {
                setupCamera()

                // Check voice permission
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if !self.voiceCommandManager.isAuthorized {
                        self.showVoicePermissionAlert = true
                    }
                }
            } else {
                showPermissionAlert = true
            }
        }
        .onDisappear {
            cameraManager.stopSession()
            voiceCommandManager.stopListening()
            rowCountingService.stopCounting()
        }
        .sheet(isPresented: $showDiagnosis) {
            StitchDoctorDiagnosisViewSheet(
                onClose: { showDiagnosis = false },
                onSaveToNotes: nil,
                diagnosisText: diagnosisResult
            )
        }
        .alert("Camera Access Required", isPresented: $showPermissionAlert) {
            Button("Grant Access") {
                cameraPermissionManager.requestCameraPermission { granted in
                    if granted {
                        setupCamera()
                    } else {
                        appState.navigateTo(.dashboard)
                    }
                }
            }
            Button("Go to Settings") {
                cameraPermissionManager.openAppSettings()
            }
            Button("Cancel", role: .cancel) {
                appState.navigateTo(.dashboard)
            }
        } message: {
            Text("StitchVision needs camera access to count your stitches and detect patterns. Please grant camera permission to use Work Mode.")
        }
        .alert("Voice Commands", isPresented: $showVoicePermissionAlert) {
            Button("Enable") {
                voiceCommandManager.requestAuthorization()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if self.voiceCommandManager.isAuthorized {
                        self.voiceCommandManager.startListening()
                    }
                }
            }
            Button("Skip", role: .cancel) { }
        } message: {
            Text("Enable voice commands for hands-free row counting? Say things like \"row done\" or \"undo\".")
        }
        .alert("No Active Project", isPresented: $showNoProjectAlert) {
            Button("OK") {
                appState.navigateTo(.dashboard)
            }
        } message: {
            Text("You don't have an active project selected. Please select or create a project before starting a session.")
        }
        .sheet(isPresented: $showPatternLibrary) {
            PatternLibraryView(onPatternSelected: { pattern in
                selectedPattern = pattern
                rowCountingService.setRowCount(pattern.currentRow)
            })
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(feature: proFeatureRequested)
        }
    }
    
    // MARK: - Helper Methods

    private func runStitchDoctor() {
        guard let pixelBuffer = latestFrame else { return }

        // Convert frame to UIImage
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent),
              let image = UIImage(data: UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.8)!) else { return }

        isDiagnosing = true
        diagnosisResult = nil
        showDiagnosis = true

        AICoachProService.shared.detectMistakes(image: image) { response in
            DispatchQueue.main.async {
                self.isDiagnosing = false
                self.diagnosisResult = response?.message ?? "Unable to analyze. Please try again."
            }
        }
    }

    private func setupCamera() {
        cameraManager.delegate = cameraDelegate
        let rowCounter = rowCountingService
        cameraDelegate.onFrameReceived = { pixelBuffer in
            guard !self.isPaused else { return }
            self.latestFrame = pixelBuffer
            rowCounter.processFrame(pixelBuffer)

            // Update pattern progress if pattern is selected
            if let pattern = self.selectedPattern {
                let currentRow = rowCounter.rowCount
                var completedRows = pattern.completedRows
                if currentRow > 0 {
                    completedRows.insert(currentRow - 1)
                }
                PatternStorageService.shared.updateProgress(
                    for: pattern.id,
                    currentRow: currentRow,
                    completedRows: completedRows
                )
            }
        }
        cameraDelegate.onError = { error in
            print("Camera error: \(error.localizedDescription)")
        }
        rowCountingService.setRowCount(self.initialRowCount)
        rowCountingService.startCounting()
        cameraManager.startSession()

        // Setup voice commands
        setupVoiceCommands()
    }

    private func setupVoiceCommands() {
        voiceCommandManager.requestAuthorization()

        voiceCommandManager.onCommandReceived = { command in

            switch command {
            case .countRow:
                rowCountingService.voiceIncrement()
                feedbackController.provideFeedback(.rowCounted)

            case .undo:
                rowCountingService.manualDecrement()
                feedbackController.provideFeedback(.undo)

            case .pause:
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPaused = true
                }
                rowCountingService.stopCounting()

            case .resume:
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPaused = false
                }
                rowCountingService.startCounting()

            case .endSession:
                handleExit()

            case .addMarker(let name):
                feedbackController.provideFeedback(.markerAdded)
                print("Marker added: \(name)")

            case .unknown(let text):
                print("Unknown command: \(text)")
            }
        }

        // Start listening if authorized
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.voiceCommandManager.isAuthorized {
                self.voiceCommandManager.startListening()
            }
        }
    }
    
    private func togglePause() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isPaused.toggle()
        }
    }
    
    private func handleExit() {
        guard projectStore.getActiveProject() != nil else {
            // Stop services and show alert, then navigate back
            cameraManager.stopSession()
            voiceCommandManager.stopListening()
            rowCountingService.stopCounting()
            showNoProjectAlert = true
            return
        }

        let timeSpent = Int(Date().timeIntervalSince(sessionStartTime) / 60)
        let rowsKnit = rowCountingService.rowCount - initialRowCount

        // Update app state with session data (actual save happens in SessionSummaryView)
        appState.selectedProjectId = projectStore.getActiveProject()?.id
        appState.updateSessionData(rowsKnit: max(0, rowsKnit), timeSpent: timeSpent)

        // Save pattern progress if pattern is selected
        if let pattern = selectedPattern {
            var completedRows = pattern.completedRows
            if rowCountingService.rowCount > 0 {
                completedRows.insert(rowCountingService.rowCount - 1)
            }
            PatternStorageService.shared.updateProgress(
                for: pattern.id,
                currentRow: rowCountingService.rowCount,
                completedRows: completedRows
            )
        }

        // Provide feedback
        feedbackController.provideFeedback(.sessionEnded)

        appState.navigateTo(.sessionSummary)
    }
    
    private func timeAgo(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 {
            return "\(seconds)s ago"
        } else {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        }
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
            HStack(spacing: 8) {
                Circle().fill(.black).frame(width: 5, height: 5)
                Circle().fill(.black).frame(width: 5, height: 5)
            }
            .offset(y: -4)
            
            // Smile - very close to eyes
            Path { path in
                path.move(to: CGPoint(x: -7, y: 0))
                path.addQuadCurve(to: CGPoint(x: 7, y: 0), control: CGPoint(x: 0, y: 4))
            }
            .stroke(.black, lineWidth: 2)
            .offset(y: 3)
            
            // Cheeks - very close to face
            HStack(spacing: 16) {
                Ellipse().fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6)).frame(width: 6, height: 4)
                Ellipse().fill(Color(red: 0.83, green: 0.50, blue: 0.44).opacity(0.6)).frame(width: 6, height: 4)
            }
            .offset(y: 1)
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
            HStack(spacing: 8) {
                Circle().fill(.black).frame(width: 5, height: 5)
                Circle().fill(.black).frame(width: 5, height: 5)
            }
            .offset(y: -4)
            
            // Neutral Mouth - very close to eyes
            Rectangle()
                .fill(.black)
                .frame(width: 12, height: 2)
                .cornerRadius(1)
                .offset(y: 2)
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
            HStack(spacing: 8) {
                Circle().fill(.black).frame(width: 4, height: 4)
                Circle().fill(.black).frame(width: 6, height: 6)
            }
            .offset(y: -4)
            
            // Confused Mouth (wavy) - very close to eyes
            Path { path in
                path.move(to: CGPoint(x: -6, y: 0))
                path.addQuadCurve(to: CGPoint(x: 0, y: 2), control: CGPoint(x: -3, y: 2))
                path.addQuadCurve(to: CGPoint(x: 6, y: 0), control: CGPoint(x: 3, y: 2))
            }
            .stroke(.black, lineWidth: 2)
            .offset(y: 3)
            
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

struct StitchDoctorDiagnosisViewSheet: View {
    let onClose: () -> Void
    let onSaveToNotes: (() -> Void)?
    let diagnosisText: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: diagnosisText == nil ? "stethoscope" : "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(diagnosisText == nil ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.561, green: 0.659, blue: 0.533))
                    .padding(.top, 32)

                Text("Stitch Doctor")
                    .font(.title2)
                    .fontWeight(.bold)

                if let text = diagnosisText {
                    ScrollView {
                        Text(text)
                            .font(.body)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                            .padding()
                    }
                } else {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Analyzing your stitches...")
                            .font(.body)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                    .padding()
                }

                Spacer()

                if let saveAction = onSaveToNotes, diagnosisText != nil {
                    Button("Save to Notes") {
                        saveAction()
                    }
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .padding(.bottom, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    onClose()
                }
            )
        }
    }
}

