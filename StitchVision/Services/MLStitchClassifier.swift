import Foundation
import Vision
import CoreML
import AVFoundation
import Combine

// MARK: - Stitch Classification Result

struct StitchClassification {
    let isKnittingMotion: Bool
    let confidence: Float
    let motionType: MotionType
    
    enum MotionType: String {
        case rowComplete = "Row Complete"
        case inProgress = "In Progress"
        case idle = "Idle"
        case handMovement = "Hand Movement"
        case backgroundNoise = "Background Noise"
    }
}

// MARK: - ML Stitch Classifier

class MLStitchClassifier: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var lastClassification: StitchClassification?
    @Published var isProcessing: Bool = false
    
    // MARK: - Properties
    
    private let visionQueue = DispatchQueue(label: "com.stitchvision.mlclassifier", qos: .userInitiated)
    private var frameBuffer: [CVPixelBuffer] = []
    private let bufferSize = 15 // Analyze 15 frames (0.5 seconds at 30fps)
    
    // Feature extractors
    private var motionAnalyzer: MotionFeatureAnalyzer
    private var colorAnalyzer: ColorFeatureAnalyzer
    private var patternAnalyzer: PatternFeatureAnalyzer
    
    // MARK: - Initialization
    
    init() {
        self.motionAnalyzer = MotionFeatureAnalyzer()
        self.colorAnalyzer = ColorFeatureAnalyzer()
        self.patternAnalyzer = PatternFeatureAnalyzer()
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
            
            // Extract features and classify
            self.classifyMotion()
        }
    }
    
    // MARK: - Classification Logic
    
    private func classifyMotion() {
        // Extract features from frame buffer
        let motionFeatures = motionAnalyzer.analyze(frames: frameBuffer)
        let colorFeatures = colorAnalyzer.analyze(frames: frameBuffer)
        let patternFeatures = patternAnalyzer.analyze(frames: frameBuffer)
        
        // Combine features for classification
        let classification = classify(
            motion: motionFeatures,
            color: colorFeatures,
            pattern: patternFeatures
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.lastClassification = classification
            self?.isProcessing = false
        }
    }
    
    private func classify(
        motion: MotionFeatures,
        color: ColorFeatures,
        pattern: PatternFeatures
    ) -> StitchClassification {
        
        // Rule-based classification (can be replaced with CoreML model)
        
        // Check if motion is consistent with knitting
        let hasHorizontalMotion = abs(motion.averageHorizontalVelocity) > 0.1
        let hasLowVerticalMotion = abs(motion.averageVerticalVelocity) < 0.05
        let hasConsistentDirection = motion.directionConsistency > 0.7
        
        // Check if colors suggest yarn (not skin or background)
        let hasYarnColors = color.dominantColorSaturation > 0.3
        let hasConsistentColor = color.colorConsistency > 0.6
        
        // Check if pattern suggests repetitive motion
        let hasRepetitiveMotion = pattern.repetitionScore > 0.5
        let hasKnittingRhythm = pattern.rhythmScore > 0.6
        
        // Calculate confidence scores
        let motionScore = (hasHorizontalMotion ? 0.3 : 0.0) +
                         (hasLowVerticalMotion ? 0.2 : 0.0) +
                         (hasConsistentDirection ? 0.3 : 0.0)
        
        let colorScore = (hasYarnColors ? 0.3 : 0.0) +
                        (hasConsistentColor ? 0.2 : 0.0)
        
        let patternScore = (hasRepetitiveMotion ? 0.25 : 0.0) +
                          (hasKnittingRhythm ? 0.25 : 0.0)
        
        let totalConfidence = motionScore + colorScore + patternScore
        
        // Determine motion type
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
}

// MARK: - Motion Feature Analyzer

class MotionFeatureAnalyzer {
    
    func analyze(frames: [CVPixelBuffer]) -> MotionFeatures {
        guard frames.count >= 2 else {
            return MotionFeatures()
        }
        
        var horizontalVelocities: [Float] = []
        var verticalVelocities: [Float] = []
        var speeds: [Float] = []
        
        // Analyze motion between consecutive frames
        for i in 1..<frames.count {
            let motion = calculateMotion(from: frames[i-1], to: frames[i])
            horizontalVelocities.append(motion.horizontal)
            verticalVelocities.append(motion.vertical)
            speeds.append(motion.speed)
        }
        
        let avgHorizontal = horizontalVelocities.reduce(0, +) / Float(horizontalVelocities.count)
        let avgVertical = verticalVelocities.reduce(0, +) / Float(verticalVelocities.count)
        let avgSpeed = speeds.reduce(0, +) / Float(speeds.count)
        
        // Calculate direction consistency
        let positiveCount = horizontalVelocities.filter { $0 > 0 }.count
        let directionConsistency = Float(max(positiveCount, horizontalVelocities.count - positiveCount)) / Float(horizontalVelocities.count)
        
        // Detect completion signal (sudden stop or direction change)
        let hasCompletionSignal = detectCompletionSignal(velocities: horizontalVelocities)
        
        return MotionFeatures(
            averageHorizontalVelocity: avgHorizontal,
            averageVerticalVelocity: avgVertical,
            averageSpeed: avgSpeed,
            directionConsistency: directionConsistency,
            hasCompletionSignal: hasCompletionSignal
        )
    }
    
    private func calculateMotion(from: CVPixelBuffer, to: CVPixelBuffer) -> (horizontal: Float, vertical: Float, speed: Float) {
        // Simplified motion calculation
        // In production, use VNGenerateOpticalFlowRequest
        
        // For now, return mock values
        // This would be replaced with actual optical flow analysis
        let horizontal = Float.random(in: -0.2...0.2)
        let vertical = Float.random(in: -0.1...0.1)
        let speed = sqrt(horizontal * horizontal + vertical * vertical)
        
        return (horizontal, vertical, speed)
    }
    
    private func detectCompletionSignal(velocities: [Float]) -> Bool {
        guard velocities.count >= 3 else { return false }
        
        // Check for sudden deceleration at the end
        let recentVelocities = Array(velocities.suffix(3))
        let avgRecent = recentVelocities.reduce(0, +) / Float(recentVelocities.count)
        
        let earlierVelocities = Array(velocities.prefix(velocities.count - 3))
        let avgEarlier = earlierVelocities.reduce(0, +) / Float(earlierVelocities.count)
        
        // Completion signal: motion was happening, then stopped
        return abs(avgEarlier) > 0.1 && abs(avgRecent) < 0.05
    }
}

// MARK: - Color Feature Analyzer

class ColorFeatureAnalyzer {
    
    func analyze(frames: [CVPixelBuffer]) -> ColorFeatures {
        guard let lastFrame = frames.last else {
            return ColorFeatures()
        }
        
        // Analyze color properties of the center region
        let colors = extractColors(from: lastFrame)
        
        let saturation = calculateAverageSaturation(colors: colors)
        let consistency = calculateColorConsistency(frames: frames)
        
        return ColorFeatures(
            dominantColorSaturation: saturation,
            colorConsistency: consistency
        )
    }
    
    private func extractColors(from pixelBuffer: CVPixelBuffer) -> [UIColor] {
        // Simplified color extraction
        // In production, sample pixels from ROI
        return [
            UIColor(red: 0.8, green: 0.3, blue: 0.4, alpha: 1.0),
            UIColor(red: 0.7, green: 0.4, blue: 0.5, alpha: 1.0)
        ]
    }
    
    private func calculateAverageSaturation(colors: [UIColor]) -> Float {
        var totalSaturation: CGFloat = 0
        
        for color in colors {
            var saturation: CGFloat = 0
            color.getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
            totalSaturation += saturation
        }
        
        return Float(totalSaturation / CGFloat(colors.count))
    }
    
    private func calculateColorConsistency(frames: [CVPixelBuffer]) -> Float {
        // Measure how consistent colors are across frames
        // High consistency = likely yarn (not moving hands)
        return 0.7 // Mock value
    }
}

// MARK: - Pattern Feature Analyzer

class PatternFeatureAnalyzer {
    
    func analyze(frames: [CVPixelBuffer]) -> PatternFeatures {
        // Analyze temporal patterns in motion
        
        let repetitionScore = detectRepetitiveMotion(frames: frames)
        let rhythmScore = detectKnittingRhythm(frames: frames)
        
        return PatternFeatures(
            repetitionScore: repetitionScore,
            rhythmScore: rhythmScore
        )
    }
    
    private func detectRepetitiveMotion(frames: [CVPixelBuffer]) -> Float {
        // Detect if motion repeats in a pattern
        // Knitting has characteristic repetitive motion
        return 0.6 // Mock value
    }
    
    private func detectKnittingRhythm(frames: [CVPixelBuffer]) -> Float {
        // Detect the rhythm of knitting (pull, wrap, pull through)
        // This would analyze motion frequency and patterns
        return 0.65 // Mock value
    }
}

// MARK: - Feature Structures

struct MotionFeatures {
    var averageHorizontalVelocity: Float = 0
    var averageVerticalVelocity: Float = 0
    var averageSpeed: Float = 0
    var directionConsistency: Float = 0
    var hasCompletionSignal: Bool = false
}

struct ColorFeatures {
    var dominantColorSaturation: Float = 0
    var colorConsistency: Float = 0
}

struct PatternFeatures {
    var repetitionScore: Float = 0
    var rhythmScore: Float = 0
}
