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
        case rowCounted
        case undo
        case voiceCommandRecognized
        case error
        case markerAdded
        case sessionStarted
        case sessionEnded
    }

    // MARK: - Public Methods

    func provideFeedback(_ type: FeedbackType) {
        switch type {
        case .rowCounted:
            triggerHaptic(style: .medium)
            playSound(named: "success")
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
            playSound(named: "error")

        case .markerAdded:
            triggerHaptic(style: .medium)
            triggerNotification(.success)
            showMessage("Marker added")

        case .sessionStarted:
            triggerHaptic(style: .medium)
            showMessage("Session started")

        case .sessionEnded:
            triggerHaptic(style: .heavy)
            showMessage("Session saved")
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

    func playSound(named name: String) {
        guard soundEnabled else { return }

        // Load sound from bundle (sounds should be added to project)
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            // System sounds fallback
            if name == "success" {
                AudioServicesPlaySystemSound(1057) // Taptic "peek" sound
            } else if name == "error" {
                AudioServicesPlaySystemSound(1053) // Taptic error sound
            }
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
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
