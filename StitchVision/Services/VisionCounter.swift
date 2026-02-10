import Foundation
import Vision
import AVFoundation
import Combine

// MARK: - Vision Counter Delegate

protocol VisionCounterDelegate: AnyObject {
    func visionCounter(_ counter: VisionCounter, didUpdateCount count: Int)
    func visionCounter(_ counter: VisionCounter, didUpdateConfidence confidence: Double)
    func visionCounter(_ counter: VisionCounter, didDetectMotion vector: CGVector)
}

// MARK: - Vision Counter Configuration

struct VisionCounterConfig {
    var motionThreshold: Float = 0.15 // Minimum motion to trigger count
    var debounceInterval: TimeInterval = 5.0 // Seconds to wait after count
    var regionOfInterest: CGRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5) // Center 50%
    var isLeftHanded: Bool = false // Direction preference
    var confidenceThreshold: Float = 0.7 // Minimum confidence to count
}

// MARK: - Vision Counter

class VisionCounter: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentCount: Int = 0
    @Published var confidence: Double = 0.0
    @Published var isProcessing: Bool = false
    @Published var lastMotionVector: CGVector = .zero
    
    // MARK: - Properties
    
    weak var delegate: VisionCounterDelegate?
    var config: VisionCounterConfig
    
    private var previousPixelBuffer: CVPixelBuffer?
    private var lastCountTime: Date?
    private var isDebouncing: Bool = false
    
    private let visionQueue = DispatchQueue(label: "com.stitchvision.vision", qos: .userInitiated)
    
    // MARK: - Initialization
    
    init(config: VisionCounterConfig = VisionCounterConfig()) {
        self.config = config
        super.init()
    }
    
    // MARK: - Public Methods
    
    func resetCount() {
        currentCount = 0
        lastCountTime = nil
        isDebouncing = false
        previousPixelBuffer = nil
    }
    
    func updateConfig(_ newConfig: VisionCounterConfig) {
        self.config = newConfig
    }
    
    // MARK: - Process Sample Buffer
    
    func processSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard !isDebouncing else { return }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // Need two frames to calculate optical flow
        guard let previousBuffer = previousPixelBuffer else {
            previousPixelBuffer = pixelBuffer
            return
        }
        
        isProcessing = true
        
        // Perform optical flow analysis on background queue
        visionQueue.async { [weak self] in
            self?.performOpticalFlowAnalysis(
                current: pixelBuffer,
                previous: previousBuffer
            )
        }
        
        // Store current buffer for next frame
        previousPixelBuffer = pixelBuffer
    }
    
    // MARK: - Optical Flow Analysis
    
    private func performOpticalFlowAnalysis(current: CVPixelBuffer, previous: CVPixelBuffer) {
        // Create optical flow request
        let request = VNGenerateOpticalFlowRequest(
            targetedCVPixelBuffer: current,
            options: [:]
        )
        
        // Configure request
        request.computationAccuracy = .high
        request.outputPixelFormat = kCVPixelFormatType_TwoComponent32Float
        
        // Create request handler
        let handler = VNImageRequestHandler(
            cvPixelBuffer: previous,
            options: [:]
        )
        
        do {
            // Perform the request
            try handler.perform([request])
            
            // Process results
            if let observation = request.results?.first as? VNPixelBufferObservation {
                processOpticalFlowObservation(observation)
            }
        } catch {
            print("Optical flow error: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                self?.isProcessing = false
            }
        }
    }
    
    // MARK: - Process Optical Flow Observation
    
    private func processOpticalFlowObservation(_ observation: VNPixelBufferObservation) {
        let pixelBuffer = observation.pixelBuffer
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else {
            DispatchQueue.main.async { [weak self] in
                self?.isProcessing = false
            }
            return
        }
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        
        // Calculate ROI bounds
        let roi = config.regionOfInterest
        let startX = Int(Float(width) * Float(roi.minX))
        let endX = Int(Float(width) * Float(roi.maxX))
        let startY = Int(Float(height) * Float(roi.minY))
        let endY = Int(Float(height) * Float(roi.maxY))
        
        // Accumulate vectors in ROI
        var totalX: Float = 0
        var totalY: Float = 0
        var pixelCount: Int = 0
        
        for y in startY..<endY {
            let rowStart = baseAddress + (y * bytesPerRow)
            
            for x in startX..<endX {
                let pixelOffset = x * MemoryLayout<Float>.size * 2
                let pixelAddress = rowStart + pixelOffset
                
                let vectorPointer = pixelAddress.assumingMemoryBound(to: Float.self)
                let vx = vectorPointer[0]
                let vy = vectorPointer[1]
                
                totalX += vx
                totalY += vy
                pixelCount += 1
            }
        }
        
        // Calculate average motion vector
        guard pixelCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.isProcessing = false
            }
            return
        }
        
        let avgX = totalX / Float(pixelCount)
        let avgY = totalY / Float(pixelCount)
        let magnitude = sqrt(avgX * avgX + avgY * avgY)
        
        // Calculate confidence based on motion consistency
        let calculatedConfidence = min(1.0, Double(magnitude) / 0.5)
        
        // Update on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.confidence = calculatedConfidence
            self.lastMotionVector = CGVector(dx: CGFloat(avgX), dy: CGFloat(avgY))
            self.isProcessing = false
            
            // Notify delegate
            self.delegate?.visionCounter(self, didUpdateConfidence: calculatedConfidence)
            self.delegate?.visionCounter(self, didDetectMotion: self.lastMotionVector)
            
            // Check if motion should trigger a count
            self.evaluateMotionForCount(x: avgX, y: avgY, magnitude: magnitude, confidence: Float(calculatedConfidence))
        }
    }
    
    // MARK: - Evaluate Motion for Count
    
    private func evaluateMotionForCount(x: Float, y: Float, magnitude: Float, confidence: Float) {
        // Check if we're in debounce period
        if let lastCount = lastCountTime {
            let timeSinceLastCount = Date().timeIntervalSince(lastCount)
            if timeSinceLastCount < config.debounceInterval {
                return
            }
        }
        
        // Check confidence threshold
        guard confidence >= config.confidenceThreshold else {
            return
        }
        
        // Check motion threshold
        guard magnitude >= config.motionThreshold else {
            return
        }
        
        // Determine if motion is in the correct direction
        let shouldCount: Bool
        
        if config.isLeftHanded {
            // Right-to-left motion (negative x)
            shouldCount = x < -config.motionThreshold
        } else {
            // Left-to-right motion (positive x)
            shouldCount = x > config.motionThreshold
        }
        
        if shouldCount {
            incrementCount()
        }
    }
    
    // MARK: - Increment Count
    
    private func incrementCount() {
        currentCount += 1
        lastCountTime = Date()
        isDebouncing = true
        
        // Notify delegate
        delegate?.visionCounter(self, didUpdateCount: currentCount)
        
        // Reset debounce after interval
        DispatchQueue.main.asyncAfter(deadline: .now() + config.debounceInterval) { [weak self] in
            self?.isDebouncing = false
        }
        
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Manual Count Adjustment
    
    func manualIncrement() {
        currentCount += 1
        delegate?.visionCounter(self, didUpdateCount: currentCount)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func manualDecrement() {
        currentCount = max(0, currentCount - 1)
        delegate?.visionCounter(self, didUpdateCount: currentCount)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
