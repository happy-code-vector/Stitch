import Foundation
import Vision
import AVFoundation
import Combine

// MARK: - Hybrid Vision Counter
// Combines optical flow (fast) with ML classification (accurate)

class HybridVisionCounter: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentCount: Int = 0
    @Published var confidence: Double = 0.0
    @Published var isProcessing: Bool = false
    @Published var lastMotionVector: CGVector = .zero
    @Published var classificationResult: StitchClassification?
    
    // MARK: - Properties
    
    weak var delegate: VisionCounterDelegate?
    var config: VisionCounterConfig
    
    private let opticalFlowCounter: VisionCounter
    private let mlClassifier: MLStitchClassifier
    
    private var lastCountTime: Date?
    private var isDebouncing: Bool = false
    
    private var pendingCount: Bool = false
    private var pendingConfidence: Float = 0
    
    // MARK: - Initialization
    
    init(config: VisionCounterConfig = VisionCounterConfig()) {
        self.config = config
        self.opticalFlowCounter = VisionCounter(config: config)
        self.mlClassifier = MLStitchClassifier()
        
        setupObservers()
    }
    
    private func setupObservers() {
        // Observe optical flow counter
        opticalFlowCounter.$confidence
            .sink { [weak self] confidence in
                self?.confidence = confidence
            }
            .store(in: &cancellables)
        
        opticalFlowCounter.$lastMotionVector
            .sink { [weak self] vector in
                self?.lastMotionVector = vector
            }
            .store(in: &cancellables)
        
        // Observe ML classifier
        mlClassifier.$lastClassification
            .sink { [weak self] classification in
                self?.handleClassification(classification)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Process Sample Buffer
    
    func processSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard !isDebouncing else { return }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        isProcessing = true
        
        // Step 1: Fast optical flow detection
        opticalFlowCounter.processSampleBuffer(sampleBuffer)
        
        // Step 2: ML classification for validation
        mlClassifier.processFrame(pixelBuffer)
    }
    
    // MARK: - Handle Classification
    
    private func handleClassification(_ classification: StitchClassification?) {
        guard let classification = classification else { return }
        
        classificationResult = classification
        
        // Check if optical flow detected motion AND ML confirms it's knitting
        if pendingCount && classification.isKnittingMotion {
            // Both systems agree - high confidence count
            if classification.motionType == .rowComplete {
                incrementCount(confidence: classification.confidence)
            }
        } else if pendingCount && !classification.isKnittingMotion {
            // Optical flow detected motion but ML says it's not knitting
            // Likely hand movement or background noise - ignore
            print("False positive filtered by ML: \(classification.motionType.rawValue)")
        }
        
        pendingCount = false
        isProcessing = false
    }
    
    // MARK: - Increment Count
    
    private func incrementCount(confidence: Float) {
        currentCount += 1
        lastCountTime = Date()
        isDebouncing = true
        
        // Notify delegate
        delegate?.visionCounter(opticalFlowCounter, didUpdateCount: currentCount)
        
        // Reset debounce after interval
        DispatchQueue.main.asyncAfter(deadline: .now() + config.debounceInterval) { [weak self] in
            self?.isDebouncing = false
        }
        
        // Provide haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Public Methods
    
    func resetCount() {
        currentCount = 0
        lastCountTime = nil
        isDebouncing = false
        opticalFlowCounter.resetCount()
        mlClassifier.reset()
    }
    
    func updateConfig(_ newConfig: VisionCounterConfig) {
        self.config = newConfig
        opticalFlowCounter.updateConfig(newConfig)
    }
    
    func manualIncrement() {
        currentCount += 1
        delegate?.visionCounter(opticalFlowCounter, didUpdateCount: currentCount)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func manualDecrement() {
        currentCount = max(0, currentCount - 1)
        delegate?.visionCounter(opticalFlowCounter, didUpdateCount: currentCount)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// MARK: - Vision Counter Delegate Extension

extension HybridVisionCounter: VisionCounterDelegate {
    func visionCounter(_ counter: VisionCounter, didUpdateCount count: Int) {
        // Optical flow detected a potential count
        // Wait for ML classification to confirm
        pendingCount = true
    }
    
    func visionCounter(_ counter: VisionCounter, didUpdateConfidence confidence: Double) {
        // Update confidence from optical flow
        self.confidence = confidence
        delegate?.visionCounter(counter, didUpdateConfidence: confidence)
    }
    
    func visionCounter(_ counter: VisionCounter, didDetectMotion vector: CGVector) {
        // Update motion vector
        self.lastMotionVector = vector
        delegate?.visionCounter(counter, didDetectMotion: vector)
    }
}
