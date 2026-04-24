import Foundation
import UIKit
import AVFoundation

/// Unified feedback controller for haptic, audio, and visual feedback
class FeedbackController: ObservableObject {

    // MARK: - Published Properties

    @Published var hapticEnabled: Bool = true
    @Published var soundEnabled: Bool = false
    @Published var lastMessage: String = ""
    @Published var showMessage: Bool = false

    // MARK: - Private Properties

    private var audioPlayer: AVAudioPlayer?

    // MARK: - Feedback Types

    enum FeedbackType {
        case rowCounted          // Single firm tap (medium impact)
        case undo                // Light tap
        case voiceCommandRecognized
        case error               // Heavy double buzz
        case markerAdded         // Double light tap (stitch marker)
        case sessionStarted
        case sessionEnded
        case calibrationSuccess  // Rising triple tap
        case limitHit            // Heavy double buzz
        case patternStepComplete // Soft single tap
        case repeatCompleted     // Double light tap
    }

    // MARK: - Public Methods

    func provideFeedback(_ type: FeedbackType) {
        switch type {
        case .rowCounted:
            triggerHaptic(style: .medium)
            playClickSound()
            showMessage("Row counted!")

        case .undo:
            triggerHaptic(style: .light)
            showMessage("Undo")

        case .voiceCommandRecognized:
            triggerHaptic(style: .medium)
            triggerNotification(.success)

        case .error:
            triggerHaptic(style: .heavy)
            triggerNotification(.error)

        case .markerAdded:
            triggerHaptic(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.triggerHaptic(style: .light)
            }
            showMessage("Marker added")

        case .sessionStarted:
            triggerHaptic(style: .medium)
            showMessage("Session started")

        case .sessionEnded:
            triggerHaptic(style: .heavy)
            showMessage("Session saved")

        case .calibrationSuccess:
            // Rising triple tap — intensity 0.4, 0.7, 1.0
            triggerHaptic(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.triggerHaptic(style: .medium)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.triggerHaptic(style: .heavy)
            }

        case .limitHit:
            triggerNotification(.error)

        case .patternStepComplete:
            triggerHaptic(style: .soft)

        case .repeatCompleted:
            triggerHaptic(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.triggerHaptic(style: .light)
            }
        }
    }

    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard hapticEnabled else { return }

        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    func triggerNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard hapticEnabled else { return }

        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    func triggerSelection() {
        guard hapticEnabled else { return }

        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    // MARK: - Sound

    func playClickSound() {
        guard soundEnabled else { return }

        // Generate a programmatic 440Hz click, 80ms duration (PRD A.3)
        let sampleRate: Double = 44100
        let duration: Double = 0.08
        let frequency: Double = 440.0
        let sampleCount = Int(sampleRate * duration)
        var samples = [Int16](repeating: 0, count: sampleCount)

        for i in 0..<sampleCount {
            let t = Double(i) / sampleRate
            let envelope = min(1.0, min(Double(i) / 200.0, Double(sampleCount - i) / 200.0))
            let value = sin(2.0 * .pi * frequency * t) * envelope * 0.3
            samples[i] = Int16(value * Double(Int16.max))
        }

        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "click.wav")
        let headerSize = 44
        let dataSize = sampleCount * 2
        var data = Data(capacity: headerSize + dataSize)

        // WAV header
        data.append(contentsOf: [UInt8]("RIFF".utf8))
        appendInt32(&data, UInt32(36 + dataSize))
        data.append(contentsOf: [UInt8]("WAVE".utf8))
        data.append(contentsOf: [UInt8]("fmt ".utf8))
        appendInt32(&data, 16) // chunk size
        appendInt16(&data, 1)  // PCM
        appendInt16(&data, 1)  // mono
        appendInt32(&data, UInt32(sampleRate))
        appendInt32(&data, UInt32(sampleRate * 2))
        appendInt16(&data, 2)  // block align
        appendInt16(&data, 16) // bits per sample
        data.append(contentsOf: [UInt8]("data".utf8))
        appendInt32(&data, UInt32(dataSize))
        for sample in samples {
            var s = sample.littleEndian
            data.append(Data(bytes: &s, count: 2))
        }

        do {
            try data.write(to: url)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.3
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            AudioServicesPlaySystemSound(1057)
        }
    }

    private func appendInt16(_ data: inout Data, _ value: UInt16) {
        var v = value.littleEndian
        data.append(Data(bytes: &v, count: 2))
    }

    private func appendInt32(_ data: inout Data, _ value: UInt32) {
        var v = value.littleEndian
        data.append(Data(bytes: &v, count: 4))
    }

    // MARK: - Visual Messages

    private func showMessage(_ text: String) {
        DispatchQueue.main.async {
            self.lastMessage = text
            self.showMessage = true

            // Auto-hide after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showMessage = false
            }
        }
    }
}
