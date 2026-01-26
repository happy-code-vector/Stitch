import SwiftUI

struct HowItWorksView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentSlide = 0
    
    let slides = [
        HowItWorksSlide(
            title: "Point Your Camera",
            description: "Simply point your phone at your knitting project",
            visual: .aiDetection
        ),
        HowItWorksSlide(
            title: "AI Counts for You",
            description: "Our AI automatically detects and counts your stitches in real-time",
            visual: .trustLine
        ),
        HowItWorksSlide(
            title: "Stay in Flow",
            description: "Keep knitting while StitchVision tracks your progress",
            visual: .controlPanel
        )
    ]
    
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
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("How It Works")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                    
                    Text("See StitchVision in action")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)
                
                // Slide content
                TabView(selection: $currentSlide) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 32) {
                            // Visual
                            HowItWorksVisualView(slide: slides[index])
                                .frame(height: 300)
                            
                            // Text content
                            VStack(spacing: 16) {
                                Text(slides[index].title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    .multilineTextAlignment(.center)
                                
                                Text(slides[index].description)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 32)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(
                                currentSlide == index 
                                ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                : Color.gray.opacity(0.3)
                            )
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentSlide)
                    }
                }
                .padding(.vertical, 24)
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentSlide > 0 {
                        Button(action: {
                            withAnimation {
                                currentSlide -= 1
                            }
                        }) {
                            Text("Previous")
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
                    }
                    
                    Button(action: {
                        if currentSlide < slides.count - 1 {
                            withAnimation {
                                currentSlide += 1
                            }
                        } else {
                            appState.navigateTo(.stats)
                        }
                    }) {
                        Text(currentSlide < slides.count - 1 ? "Next" : "Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .background(Color(red: 0.976, green: 0.969, blue: 0.949))
        .ignoresSafeArea()
    }
}

struct HowItWorksSlide {
    let title: String
    let description: String
    let visual: VisualType
    
    enum VisualType {
        case aiDetection
        case trustLine
        case controlPanel
    }
}

struct HowItWorksVisualView: View {
    let slide: HowItWorksSlide
    @State private var animateVisual = false
    
    var body: some View {
        Group {
            switch slide.visual {
            case .aiDetection:
                AIDetectionVisualView()
            case .trustLine:
                TrustLineVisualView()
            case .controlPanel:
                ControlPanelVisualView()
            }
        }
        .scaleEffect(animateVisual ? 1.0 : 0.9)
        .opacity(animateVisual ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6), value: animateVisual)
        .onAppear {
            animateVisual = true
        }
    }
}

struct AIDetectionVisualView: View {
    @State private var scanningPosition: CGFloat = 0
    @State private var confidence: Double = 0
    
    var body: some View {
        ZStack {
            // Phone frame
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                .frame(width: 200, height: 300)
            
            // Screen content
            RoundedRectangle(cornerRadius: 17)
                .fill(Color.black)
                .frame(width: 194, height: 294)
                .overlay(
                    // Knitting pattern view
                    KnittingPatternView()
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                )
                .overlay(
                    // Scanning line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color(red: 0.561, green: 0.659, blue: 0.533), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 2)
                        .offset(y: scanningPosition)
                        .animation(.linear(duration: 2).repeatForever(autoreverses: true), value: scanningPosition)
                )
                .overlay(
                    // Corner brackets
                    VStack {
                        HStack {
                            CornerBracket(corners: [.topLeft])
                            Spacer()
                            CornerBracket(corners: [.topRight])
                        }
                        Spacer()
                        HStack {
                            CornerBracket(corners: [.bottomLeft])
                            Spacer()
                            CornerBracket(corners: [.bottomRight])
                        }
                    }
                    .padding(20)
                )
            
            // AI confidence indicator
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "brain.head.profile")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    
                    Text("AI Confidence: \(Int(confidence))%")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .offset(y: 180)
        }
        .onAppear {
            scanningPosition = -140
            
            // Animate confidence
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if confidence >= 95 {
                    timer.invalidate()
                } else {
                    confidence += 2
                }
            }
        }
    }
}

struct TrustLineVisualView: View {
    @State private var glowIntensity: Double = 0.5
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.976, green: 0.969, blue: 0.949),
                            Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 280, height: 200)
            
            // Trust indicators
            VStack(spacing: 24) {
                // Accuracy badge
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .scaleEffect(glowIntensity)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glowIntensity)
                    
                    VStack(alignment: .leading) {
                        Text("99.7% Accurate")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        
                        Text("Stitch Detection")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                }
                
                // Real-time indicator
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .scaleEffect(glowIntensity * 1.2)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: glowIntensity)
                    
                    Text("Real-time Processing")
                        .font(.body)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                }
                
                // Floating mascot
                SmallHappyMascotView()
                    .offset(y: floatingOffset)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: floatingOffset)
            }
        }
        .onAppear {
            glowIntensity = 1.2
            floatingOffset = -10
        }
    }
}

struct ControlPanelVisualView: View {
    @State private var isActive = true
    @State private var rowCount = 27
    
    var body: some View {
        ZStack {
            // Control panel background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: 280, height: 200)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("StitchVision Active")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    Circle()
                        .fill(isActive ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                        .scaleEffect(isActive ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isActive)
                }
                
                // Row counter
                VStack(spacing: 8) {
                    Text("Current Row")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    
                    Text("\(rowCount)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .animation(.easeInOut(duration: 0.3), value: rowCount)
                }
                
                // Progress indicator
                HStack {
                    Text("Progress")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    
                    Spacer()
                    
                    Text("54%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        Rectangle()
                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: geometry.size.width * 0.54, height: 6)
                            .cornerRadius(3)
                            .animation(.easeInOut(duration: 2), value: isActive)
                    }
                }
                .frame(height: 6)
            }
            .padding(24)
        }
        .onAppear {
            // Simulate row counting
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                rowCount += 1
            }
        }
    }
}

// Helper Views
struct KnittingPatternView: View {
    var body: some View {
        Canvas { context, size in
            // Draw a simple knitting pattern
            let stitchWidth: CGFloat = 8
            let stitchHeight: CGFloat = 6
            let rows = Int(size.height / stitchHeight)
            let stitchesPerRow = Int(size.width / stitchWidth)
            
            for row in 0..<rows {
                for stitch in 0..<stitchesPerRow {
                    let x = CGFloat(stitch) * stitchWidth
                    let y = CGFloat(row) * stitchHeight
                    
                    let rect = CGRect(x: x, y: y, width: stitchWidth - 1, height: stitchHeight - 1)
                    context.fill(Path(rect), with: .color(Color.white.opacity(0.8)))
                    context.stroke(Path(rect), with: .color(Color.gray.opacity(0.3)), lineWidth: 0.5)
                }
            }
        }
    }
}

struct CornerBracket: View {
    let corners: UIRectCorner
    
    var body: some View {
        Path { path in
            let size: CGFloat = 20
            let thickness: CGFloat = 3
            
            if corners.contains(.topLeft) {
                // Top-left corner
                path.move(to: CGPoint(x: 0, y: size))
                path.addLine(to: CGPoint(x: 0, y: thickness))
                path.addLine(to: CGPoint(x: thickness, y: thickness))
                path.addLine(to: CGPoint(x: thickness, y: 0))
                path.addLine(to: CGPoint(x: size, y: 0))
            }
            
            if corners.contains(.topRight) {
                // Top-right corner
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: size - thickness, y: 0))
                path.addLine(to: CGPoint(x: size - thickness, y: thickness))
                path.addLine(to: CGPoint(x: size, y: thickness))
                path.addLine(to: CGPoint(x: size, y: size))
            }
            
            if corners.contains(.bottomLeft) {
                // Bottom-left corner
                path.move(to: CGPoint(x: size, y: size))
                path.addLine(to: CGPoint(x: thickness, y: size))
                path.addLine(to: CGPoint(x: thickness, y: size - thickness))
                path.addLine(to: CGPoint(x: 0, y: size - thickness))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }
            
            if corners.contains(.bottomRight) {
                // Bottom-right corner
                path.move(to: CGPoint(x: size, y: 0))
                path.addLine(to: CGPoint(x: size, y: size - thickness))
                path.addLine(to: CGPoint(x: size - thickness, y: size - thickness))
                path.addLine(to: CGPoint(x: size - thickness, y: size))
                path.addLine(to: CGPoint(x: 0, y: size))
            }
        }
        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
        .frame(width: 20, height: 20)
    }
}

struct SmallHappyMascotView: View {
    var body: some View {
        ZStack {
            // Small yarn ball
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.66, green: 0.76, blue: 0.63),
                            Color(red: 0.561, green: 0.659, blue: 0.533)
                        ],
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
            
            // Happy eyes
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 2, height: 2)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 2, height: 2)
            }
            .offset(y: -4)
            
            // Happy smile
            Path { path in
                path.move(to: CGPoint(x: -8, y: 8))
                path.addQuadCurve(to: CGPoint(x: 8, y: 8), control: CGPoint(x: 0, y: 14))
            }
            .stroke(Color.black, lineWidth: 1)
        }
    }
}