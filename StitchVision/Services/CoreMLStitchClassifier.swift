import Foundation
import CoreML
import Vision
import AVFoundation
import Combine

// MARK: - CoreML Stitch Classifier
// Wrapper for CoreML model integration

class CoreMLStitchClassifier: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var lastClassification: StitchClassification?
    @Published var isProcessing: Bool = false
    @Published var modelLoaded: Bool = false
    
    // MARK: - Properties
    
    private var model: VNCoreMLModel?
    private var frameBuffer: [CVPixelBuffer] = []
    private let bufferSize = 15 // 15 frames at 30fps = 0.5 seconds
    private let visionQueue = DispatchQueue(label: "com.stitchvision.coreml", qos: .userInitiated)
    
    // MARK: - Initialization
    
    init() {
        loadModel()
    }
    
    // MARK: - Load Model
    
    private func loadModel() {
        visionQueue.async { [weak self] in
            do {
                // Try to load the CoreML model
                // Note: Replace "StitchClassifier" with your actual model name
                
                // Option 1: If you have a .mlmodel file in your project
                if let modelURL = Bundle.main.url(forResource: "StitchClassifier", withExtension: "mlmodelc") {
                    let mlModel = try MLModel(contentsOf: modelURL)
                    let visionModel = try VNCoreMLModel(for: mlModel)
                    
                    DispatchQueue.main.async {
                        self?.model = visionModel
                        self?.modelLoaded = true
                        print("✅ CoreML model loaded successfully")
                    }
                } else {
                    // Model not found - fall back to rule-based classification
                    print("⚠️ CoreML model not found. Using rule-based classification.")
                    DispatchQueue.main.async {
                        self?.modelLoaded = false
                    }
                }
            } catch {
                print("❌ Error loading CoreML model: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.modelLoaded = false
                }
            }
        }
    }
    
    // MARK: - Process Frame
    
    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        visionQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Add to buffer
            self.frameBuffer.append(pixelBuffer)
            
            // Keep only recent frames
            if self.frameBuffer.count > self.bufferSize {
                self.frameBuffer.removeFirst()
            }
            
            // Need full buffer to classify
            guard self.frameBuffer.count == self.bufferSize else { return }
            
            DispatchQueue.main.async {
                self.isProcessing = true
            }
            
            // Classify using CoreML or fallback
            if self.modelLoaded, let model = self.model {
                self.classifyWithCoreML(model: model)
            } else {
                self.classifyWithRules()
            }
        }
    }
    
    // MARK: - CoreML Classification
    
    private func classifyWithCoreML(model: VNCoreMLModel) {
        // Create CoreML request
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                print("CoreML prediction error: \(error.localizedDescription)")
                self.classifyWithRules() // Fallback
                return
            }
            
            // Process results
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self.classifyWithRules() // Fallback
                return
            }
            
            // Convert CoreML result to our classification
            let classification = self.convertCoreMLResult(
                label: topResult.identifier,
                confidence: topResult.confidence
            )
            
            DispatchQueue.main.async {
                self.lastClassification = classification
                self.isProcessing = false
            }
        }
        
        // Perform request on last frame
        guard let lastFrame = frameBuffer.last else { return }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: lastFrame, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("CoreML request error: \(error.localizedDescription)")
            classifyWithRules() // Fallback
        }
    }
    
    private func convertCoreMLResult(label: String, confidence: Float) -> StitchClassification {
        // Map CoreML labels to our motion types
        let motionType: StitchClassification.MotionType
        
        switch label.lowercased() {
        case "row_complete", "rowcomplete", "complete":
            motionType = .rowComplete
        case "in_progress", "inprogress", "knitting":
            motionType = .inProgress
        case "idle", "still", "stopped":
            motionType = .idle
        case "hand_movement", "handmovement", "hand":
            motionType = .handMovement
        default:
            motionType = .backgroundNoise
        }
        
        let isKnitting = motionType == .rowComplete || motionType == .inProgress
        
        return StitchClassification(
            isKnittingMotion: isKnitting,
            confidence: confidence,
            motionType: motionType
        )
    }
    
    // MARK: - Rule-Based Classification (Fallback)
    
    private func classifyWithRules() {
        // Use the existing rule-based classification from MLStitchClassifier
        let motionAnalyzer = MotionFeatureAnalyzer()
        let colorAnalyzer = ColorFeatureAnalyzer()
        let patternAnalyzer = PatternFeatureAnalyzer()
        
        let motionFeatures = motionAnalyzer.analyze(frames: frameBuffer)
        let colorFeatures = colorAnalyzer.analyze(frames: frameBuffer)
        let patternFeatures = patternAnalyzer.analyze(frames: frameBuffer)
        
        let classification = classifyWithFeatures(
            motion: motionFeatures,
            color: colorFeatures,
            pattern: patternFeatures
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.lastClassification = classification
            self?.isProcessing = false
        }
    }
    
    private func classifyWithFeatures(
        motion: MotionFeatures,
        color: ColorFeatures,
        pattern: PatternFeatures
    ) -> StitchClassification {
        
        // Rule-based classification logic
        let hasHorizontalMotion = abs(motion.averageHorizontalVelocity) > 0.1
        let hasLowVerticalMotion = abs(motion.averageVerticalVelocity) < 0.05
        let hasConsistentDirection = motion.directionConsistency > 0.7
        
        let hasYarnColors = color.dominantColorSaturation > 0.3
        let hasConsistentColor = color.colorConsistency > 0.6
        
        let hasRepetitiveMotion = pattern.repetitionScore > 0.5
        let hasKnittingRhythm = pattern.rhythmScore > 0.6
        
        let motionScore = (hasHorizontalMotion ? 0.3 : 0.0) +
                         (hasLowVerticalMotion ? 0.2 : 0.0) +
                         (hasConsistentDirection ? 0.3 : 0.0)
        
        let colorScore = (hasYarnColors ? 0.3 : 0.0) +
                        (hasConsistentColor ? 0.2 : 0.0)
        
        let patternScore = (hasRepetitiveMotion ? 0.25 : 0.0) +
                          (hasKnittingRhythm ? 0.25 : 0.0)
        
        let totalConfidence = motionScore + colorScore + patternScore
        
        let motionType: StitchClassification.MotionType
        
        if totalConfidence > 0.75 && motion.hasCompletionSignal {
            motionType = .rowComplete
        } else if totalConfidence > 0.6 {
            motionType = .inProgress
        } else if motion.averageSpeed > 0.05 && !hasYarnColors {
            motionType = .handMovement
        } else if motion.averageSpeed < 0.02 {
            motionType = .idle
        } else {
            motionType = .backgroundNoise
        }
        
        let isKnitting = motionType == .rowComplete || motionType == .inProgress
        
        return StitchClassification(
            isKnittingMotion: isKnitting,
            confidence: totalConfidence,
            motionType: motionType
        )
    }
    
    // MARK: - Reset
    
    func reset() {
        frameBuffer.removeAll()
        lastClassification = nil
    }
    
    // MARK: - Model Info
    
    func getModelInfo() -> String {
        if modelLoaded {
            return "CoreML Model: Loaded ✅"
        } else {
            return "CoreML Model: Not Found (Using Rules) ⚠️"
        }
    }
}
