import SwiftUI

struct HowItWorksView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentSlide = 0
    
    let slides = [
        HowItWorksSlide(
            title: "AI Watches While You Knit",
            description: "Just knit naturally—our AI counts every row automatically",
            visual: .aiDetection
        ),
        HowItWorksSlide(
            title: "See Exactly What We Detect",
            description: "A glowing line shows where the AI is counting in real-time",
            visual: .trustLine
        ),
        HowItWorksSlide(
            title: "Never Lose Your Place",
            description: "Pause anytime, adjust manually, or let the AI handle everything",
            visual: .controlPanel
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(width: geometry.size.width * 0.7)
                        .animation(.easeOut(duration: 0.8), value: currentSlide)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 8)
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("How It Works")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .multilineTextAlignment(.center)
                        .opacity(1.0)
                        .animation(.easeOut(duration: 0.6), value: currentSlide)
                    
                    Text("See the magic in action")
                        .font(.body)
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .multilineTextAlignment(.center)
                        .opacity(1.0)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: currentSlide)
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                
                // Slide content
                TabView(selection: $currentSlide) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        VStack(spacing: 32) {
                            // Visual
                            HowItWorksVisualView(slide: slides[index])
                                .frame(maxHeight: 300)
                            
                            // Text content
                            VStack(spacing: 12) {
                                Text(slides[index].title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    .multilineTextAlignment(.center)
                                
                                Text(slides[index].description)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            }
                            .padding(.horizontal, 24)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                // Slide Indicators
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentSlide = index
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    currentSlide == index 
                                    ? Color(red: 0.561, green: 0.659, blue: 0.533)
                                    : Color(red: 0.867, green: 0.867, blue: 0.867)
                                )
                                .frame(
                                    width: currentSlide == index ? 32 : 8,
                                    height: 8
                                )
                                .animation(.easeInOut(duration: 0.3), value: currentSlide)
                        }
                    }
                }
                .padding(.vertical, 32)
                
                // Navigation buttons
                HStack(spacing: 12) {
                    if currentSlide > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentSlide -= 1
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Back")
                                    .font(.headline)
                            }
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(red: 0.867, green: 0.867, blue: 0.867), lineWidth: 2)
                            )
                        }
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentSlide)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    Button(action: {
                        if currentSlide < slides.count - 1 {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                currentSlide += 1
                            }
                        } else {
                            appState.navigateTo(.statsProblem)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(currentSlide < slides.count - 1 ? "Next" : "See the Time Savings")
                                .font(.headline)
                            if currentSlide < slides.count - 1 {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .cornerRadius(25)
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentSlide)
                }
                .padding(.horizontal, 24)
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
    @State private var scanningPosition: CGFloat = -140
    @State private var confidence: Double = 0
    @State private var showBoundingBox = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Main camera view background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.31, green: 0.31, blue: 0.31),
                            Color(red: 0.44, green: 0.44, blue: 0.44),
                            Color(red: 0.56, green: 0.56, blue: 0.56)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(4/3, contentMode: .fit)
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 8)
            
            // Simulated knitting texture
            KnittingTextureView()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(0.3)
            
            // AI Bounding Box
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 4)
                .padding(32)
                .scaleEffect(showBoundingBox ? 1.0 : 0.9)
                .opacity(showBoundingBox ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.3), value: showBoundingBox)
                .overlay(
                    // Corner brackets
                    VStack {
                        HStack {
                            CornerBracket(position: .topLeft)
                            Spacer()
                            CornerBracket(position: .topRight)
                        }
                        Spacer()
                        HStack {
                            CornerBracket(position: .bottomLeft)
                            Spacer()
                            CornerBracket(position: .bottomRight)
                        }
                    }
                    .padding(40)
                )
                .overlay(
                    // Center crosshair
                    VStack {
                        Rectangle()
                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: 32, height: 2)
                        Rectangle()
                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                            .frame(width: 2, height: 32)
                            .offset(y: -17)
                    }
                    .opacity(showBoundingBox ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.8), value: showBoundingBox)
                )
                .overlay(
                    // Scanning line
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color(red: 0.561, green: 0.659, blue: 0.533),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 4)
                        .offset(y: scanningPosition)
                        .opacity(0.6)
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: scanningPosition)
                        .padding(.horizontal, 32)
                )
            
            // Row count display
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("42")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("ROWS")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.black.opacity(0.6))
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .scaleEffect(showBoundingBox ? 1.0 : 0.8)
                    .opacity(showBoundingBox ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(0.8), value: showBoundingBox)
                    Spacer()
                }
                .padding(.bottom, 16)
            }
            
            // Confidence meter
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Confidence")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(Int(confidence))%")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.white.opacity(0.2))
                                    .frame(height: 8)
                                
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
                                    .frame(width: geometry.size.width * (confidence / 100), height: 8)
                                    .animation(.easeOut(duration: 1).delay(0.8), value: confidence)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.black.opacity(0.4))
                            .background(.ultraThinMaterial)
                    )
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .opacity(showBoundingBox ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.5), value: showBoundingBox)
                Spacer()
            }
        }
        .onAppear {
            showBoundingBox = true
            
            // Animate scanning line
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                scanningPosition = 140
            }
            
            // Animate confidence
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
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
    @State private var showTrustLine = false
    
    var body: some View {
        ZStack {
            // Main camera view background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.31, green: 0.31, blue: 0.31),
                            Color(red: 0.44, green: 0.44, blue: 0.44),
                            Color(red: 0.56, green: 0.56, blue: 0.56)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(4/3, contentMode: .fit)
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 8)
            
            // Simulated knitting texture
            KnittingTextureView()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .opacity(0.3)
            
            // AR Trust Indicator Line - Centered
            VStack {
                Spacer()
                
                // Glowing trust line
                Rectangle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .frame(height: 4)
                    .cornerRadius(2)
                    .shadow(
                        color: Color(red: 0.561, green: 0.659, blue: 0.533),
                        radius: glowIntensity * 20,
                        x: 0,
                        y: 0
                    )
                    .scaleEffect(showTrustLine ? 1.0 : 0.8)
                    .opacity(showTrustLine ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.8).delay(0.3), value: showTrustLine)
                    .overlay(
                        // Curved edges for fabric appearance
                        HStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.clear, Color(red: 0.561, green: 0.659, blue: 0.533)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 32, height: 4)
                                .opacity(0.5)
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.561, green: 0.659, blue: 0.533), Color.clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 32, height: 4)
                                .opacity(0.5)
                        }
                    )
                    .padding(.horizontal, 32)
                
                Spacer()
            }
            .overlay(
                // Floating "Row X" bubble
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 0) {
                            Text("Row 42")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.black.opacity(0.7))
                                .background(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.3), lineWidth: 1)
                                )
                        )
                        .offset(y: floatingOffset)
                        .scaleEffect(showTrustLine ? 1.0 : 0.8)
                        .opacity(showTrustLine ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: showTrustLine)
                        Spacer()
                    }
                    .padding(.bottom, 48)
                    Spacer()
                }
            )
            
            // Small mascot in corner watching
            VStack {
                HStack {
                    Spacer()
                    SmallHappyMascotView()
                        .scaleEffect(showTrustLine ? 1.0 : 0.5)
                        .opacity(showTrustLine ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.6).delay(0.8), value: showTrustLine)
                }
                .padding(.top, 16)
                .padding(.trailing, 16)
                Spacer()
            }
            
            // Label at bottom
            VStack {
                Spacer()
                Text("AI is watching here ↑")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(showTrustLine ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.6).delay(1), value: showTrustLine)
                    .padding(.bottom, 16)
            }
        }
        .onAppear {
            showTrustLine = true
            
            // Animate glow
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowIntensity = 1.2
            }
            
            // Animate floating
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(1)) {
                floatingOffset = -5
            }
        }
    }
}

struct ControlPanelVisualView: View {
    @State private var isActive = true
    @State private var rowCount = 27
    @State private var showControls = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top: Mini camera view
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.31, green: 0.31, blue: 0.31),
                            Color(red: 0.44, green: 0.44, blue: 0.44),
                            Color(red: 0.56, green: 0.56, blue: 0.56)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    // Simulated knitting
                    KnittingTextureView()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .opacity(0.2)
                )
                .overlay(
                    // Row count display
                    Text("\(rowCount)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                )
            
            // Bottom: Control Panel
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
                .overlay(
                    VStack(spacing: 16) {
                        // Status text
                        HStack {
                            Circle()
                                .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                .frame(width: 8, height: 8)
                                .scaleEffect(isActive ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isActive)
                            
                            Text("Counting Active")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        }
                        
                        // Three-button layout
                        HStack(spacing: 16) {
                            // Decrement button
                            Button(action: {}) {
                                Image(systemName: "minus")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 56, height: 56)
                                    .background(
                                        Circle()
                                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                                    )
                            }
                            .scaleEffect(showControls ? 1.0 : 0.8)
                            .opacity(showControls ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showControls)
                            
                            // Pause/Resume - larger center button
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 4, height: 16)
                                        .cornerRadius(1)
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 4, height: 16)
                                        .cornerRadius(1)
                                }
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                )
                            }
                            .scaleEffect(showControls ? 1.0 : 0.8)
                            .opacity(showControls ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showControls)
                            
                            // Increment button
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                    .frame(width: 56, height: 56)
                                    .background(
                                        Circle()
                                            .stroke(Color(red: 0.561, green: 0.659, blue: 0.533), lineWidth: 2)
                                    )
                            }
                            .scaleEffect(showControls ? 1.0 : 0.8)
                            .opacity(showControls ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showControls)
                        }
                        
                        // Helper text
                        Text("Adjust manually anytime without stopping")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .multilineTextAlignment(.center)
                            .opacity(showControls ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.6).delay(0.5), value: showControls)
                    }
                    .padding(24)
                )
                .frame(height: 180)
        }
        .onAppear {
            showControls = true
            
            // Simulate row counting
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    rowCount += 1
                }
            }
        }
    }
}

// Helper Views
struct KnittingTextureView: View {
    var body: some View {
        Canvas { context, size in
            // Draw knitting texture pattern
            let patternSize: CGFloat = 40
            let circleRadius: CGFloat = 3
            
            let cols = Int(size.width / patternSize) + 1
            let rows = Int(size.height / patternSize) + 1
            
            for row in 0..<rows {
                for col in 0..<cols {
                    let x1 = CGFloat(col) * patternSize + 10
                    let y1 = CGFloat(row) * patternSize + 10
                    let x2 = CGFloat(col) * patternSize + 30
                    let y2 = CGFloat(row) * patternSize + 10
                    let x3 = CGFloat(col) * patternSize + 20
                    let y3 = CGFloat(row) * patternSize + 25
                    
                    // Draw circles for knitting pattern
                    context.fill(
                        Path(ellipseIn: CGRect(x: x1 - circleRadius, y: y1 - circleRadius, width: circleRadius * 2, height: circleRadius * 2)),
                        with: .color(Color(red: 0.62, green: 0.71, blue: 0.59).opacity(0.4))
                    )
                    context.fill(
                        Path(ellipseIn: CGRect(x: x2 - circleRadius, y: y2 - circleRadius, width: circleRadius * 2, height: circleRadius * 2)),
                        with: .color(Color(red: 0.62, green: 0.71, blue: 0.59).opacity(0.4))
                    )
                    context.fill(
                        Path(ellipseIn: CGRect(x: x3 - circleRadius, y: y3 - circleRadius, width: circleRadius * 2, height: circleRadius * 2)),
                        with: .color(Color(red: 0.66, green: 0.76, blue: 0.63).opacity(0.3))
                    )
                }
            }
        }
    }
}

enum CornerPosition {
    case topLeft, topRight, bottomLeft, bottomRight
}

struct CornerBracket: View {
    let position: CornerPosition
    
    var body: some View {
        Path { path in
            let size: CGFloat = 24
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
        .frame(width: 24, height: 24)
    }
}

struct SmallHappyMascotView: View {
    var body: some View {
        ZStack {
            // Yarn ball body with gradient
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
                .frame(width: 48, height: 48)
            
            // Highlight
            Ellipse()
                .fill(.white.opacity(0.3))
                .frame(width: 28, height: 20)
                .offset(x: -6, y: -6)
            
            // Happy eyes
            HStack(spacing: 12) {
                VStack {
                    Circle()
                        .fill(.black)
                        .frame(width: 5, height: 5)
                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 2, height: 2)
                        .offset(x: 1, y: -3)
                }
                
                VStack {
                    Circle()
                        .fill(.black)
                        .frame(width: 5, height: 5)
                    Circle()
                        .fill(.white.opacity(0.9))
                        .frame(width: 2, height: 2)
                        .offset(x: 1, y: -3)
                }
            }
            .offset(y: -4)
            
            // Happy smile
            Path { path in
                path.move(to: CGPoint(x: -8, y: 8))
                path.addQuadCurve(to: CGPoint(x: 8, y: 8), control: CGPoint(x: 0, y: 14))
            }
            .stroke(.black, lineWidth: 2)
            .fill(.clear)
        }
    }
}