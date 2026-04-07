import Foundation
import Speech
import AVFoundation
import Combine
import UIKit

/// Supported voice commands
enum VoiceCommand: Equatable, Hashable {
    case countRow
    case undo
    case pause
    case resume
    case endSession
    case addMarker(String)
    case unknown(String)

    static func == (lhs: VoiceCommand, rhs: VoiceCommand) -> Bool {
        switch (lhs, rhs) {
        case (.countRow, .countRow): return true
        case (.undo, .undo): return true
        case (.pause, .pause): return true
        case (.resume, .resume): return true
        case (.endSession, .endSession): return true
        case (.addMarker(let a), .addMarker(let b)): return a == b
        case (.unknown(let a), .unknown(let b)): return a == b
        default: return false
        }
    }
}

/// Manages speech recognition and command parsing
class VoiceCommandManager: ObservableObject {

    // MARK: - Published Properties

    @Published var isListening: Bool = false
    @Published var isAuthorized: Bool = false
    @Published var lastRecognizedText: String = ""
    @Published var lastCommand: VoiceCommand?
    @Published var errorMessage: String?

    // MARK: - Properties

    var onCommandReceived: ((VoiceCommand) -> Void)?

    // MARK: - Private Properties

    private let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let processingQueue = DispatchQueue(label: "com.stitchvoice.voicecommand")

    // MARK: - Command Phrases

    private let commandPhrases: [VoiceCommand: [String]] = [
        .countRow: [
            "count row", "row done", "completed row", "finished row",
            "next row", "row complete", "done row", "that's a row",
            "another row", "one more row"
        ],
        .undo: [
            "undo", "go back", "revert", "back one", "minus one",
            "remove row", "uncount"
        ],
        .pause: [
            "pause", "stop", "hold on", "wait"
        ],
        .resume: [
            "resume", "continue", "keep going", "start again"
        ],
        .endSession: [
            "end session", "done working", "finish session",
            "i'm done", "all done", "complete session"
        ]
    ]

    // MARK: - Initialization

    init() {
        // Use on-device speech recognizer for offline capability
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

        // Prefer on-device recognition if available
        if #available(iOS 13, *) {
            if let recognizer = speechRecognizer, recognizer.supportsOnDeviceRecognition {
                recognizer.defaultTaskHint = .dictation
            }
        }
    }

    // MARK: - Authorization

    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.isAuthorized = true
                    self?.errorMessage = nil
                case .denied:
                    self?.isAuthorized = false
                    self?.errorMessage = "Speech recognition denied. Please enable in Settings."
                case .restricted:
                    self?.isAuthorized = false
                    self?.errorMessage = "Speech recognition restricted on this device."
                case .notDetermined:
                    self?.isAuthorized = false
                    self?.errorMessage = "Speech recognition not yet authorized."
                @unknown default:
                    self?.isAuthorized = false
                    self?.errorMessage = "Unknown authorization status."
                }
            }
        }

        // Also request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { _ in }
    }

    // MARK: - Listening Control

    func startListening() {
        guard isAuthorized else {
            requestAuthorization()
            return
        }

        guard !isListening else { return }

        // Cancel any existing task
        stopListening()

        // Configure audio session
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorMessage = "Failed to configure audio: \(error.localizedDescription)"
            return
        }

        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "Failed to create recognition request"
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        // Enable on-device recognition if available
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = true
        }

        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                let transcript = result.bestTranscription.formattedString
                DispatchQueue.main.async {
                    self.lastRecognizedText = transcript
                }

                // Only process final results to avoid false triggers
                if result.isFinal {
                    self.processCommand(transcript)
                }
            }

            if error != nil {
                // Restart listening on error (unless we stopped intentionally)
                if self.isListening {
                    self.restartListening()
                }
            }
        }

        // Configure audio input — must use inputFormat, not outputFormat.
        // outputFormat(forBus:) can return a zero sample-rate format before
        // the engine is prepared, which triggers the assertion failure.
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.inputFormat(forBus: 0)

        // Guard against a zero sample rate, which indicates the audio session
        // hasn't fully activated yet (e.g. simulator with no mic, or session
        // category not supporting input).
        guard recordingFormat.sampleRate > 0 else {
            DispatchQueue.main.async {
                self.errorMessage = "Audio input unavailable (sample rate = 0). Check microphone permissions."
            }
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        // Prepare the engine before starting so the audio graph is fully
        // resolved and hardware resources are allocated.
        audioEngine.prepare()

        // Start audio engine
        do {
            try audioEngine.start()
            DispatchQueue.main.async {
                self.isListening = true
                self.errorMessage = nil
            }
        } catch {
            errorMessage = "Failed to start audio engine: \(error.localizedDescription)"
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        recognitionRequest = nil
        recognitionTask = nil

        DispatchQueue.main.async {
            self.isListening = false
        }
    }

    private func restartListening() {
        stopListening()

        // Small delay before restarting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.startListening()
        }
    }

    // MARK: - Command Processing

    private func processCommand(_ text: String) {
        let normalizedText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // Check for marker command with name
        let markerPatterns = ["add marker", "mark"]
        for pattern in markerPatterns {
            if normalizedText.hasPrefix(pattern) {
                let markerName = String(normalizedText.dropFirst(pattern.count)).trimmingCharacters(in: .whitespaces)
                let command = VoiceCommand.addMarker(markerName.isEmpty ? "Marker" : markerName)
                handleCommand(command)
                return
            }
        }

        // Check other commands
        for (command, phrases) in commandPhrases {
            for phrase in phrases {
                if normalizedText.contains(phrase) {
                    handleCommand(command)
                    return
                }
            }
        }

        // Unknown command
        handleCommand(.unknown(normalizedText))
    }

    private func handleCommand(_ command: VoiceCommand) {
        DispatchQueue.main.async {
            self.lastCommand = command

            // Provide haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()

            switch command {
            case .unknown:
                generator.notificationOccurred(.warning)
            default:
                generator.notificationOccurred(.success)
            }

            // Call callback
            self.onCommandReceived?(command)
        }
    }

    // MARK: - Cleanup

    deinit {
        stopListening()
    }
}
