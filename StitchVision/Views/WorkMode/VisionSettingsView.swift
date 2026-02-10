import SwiftUI

struct VisionSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var visionCounter: VisionCounter
    
    @State private var motionThreshold: Double
    @State private var debounceInterval: Double
    @State private var confidenceThreshold: Double
    @State private var isLeftHanded: Bool
    
    init(visionCounter: VisionCounter) {
        self.visionCounter = visionCounter
        _motionThreshold = State(initialValue: Double(visionCounter.config.motionThreshold))
        _debounceInterval = State(initialValue: visionCounter.config.debounceInterval)
        _confidenceThreshold = State(initialValue: Double(visionCounter.config.confidenceThreshold))
        _isLeftHanded = State(initialValue: visionCounter.config.isLeftHanded)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detection Sensitivity")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Motion Threshold")
                            Spacer()
                            Text(String(format: "%.2f", motionThreshold))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $motionThreshold, in: 0.05...0.5, step: 0.05)
                        Text("Higher values require more motion to trigger a count")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Confidence Threshold")
                            Spacer()
                            Text("\(Int(confidenceThreshold * 100))%")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $confidenceThreshold, in: 0.5...0.95, step: 0.05)
                        Text("Minimum confidence required to count a row")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Timing")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Debounce Interval")
                            Spacer()
                            Text(String(format: "%.1fs", debounceInterval))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $debounceInterval, in: 1.0...10.0, step: 0.5)
                        Text("Time to wait after counting before detecting next row")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle("Left-Handed Mode", isOn: $isLeftHanded)
                    Text("Detects right-to-left motion instead of left-to-right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Current Status")) {
                    HStack {
                        Text("Row Count")
                        Spacer()
                        Text("\(visionCounter.currentCount)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Confidence")
                        Spacer()
                        Text("\(Int(visionCounter.confidence * 100))%")
                            .foregroundColor(confidenceColor)
                    }
                    
                    HStack {
                        Text("Processing")
                        Spacer()
                        if visionCounter.isProcessing {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("Idle")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        visionCounter.resetCount()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Count")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Vision Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSettings()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var confidenceColor: Color {
        if visionCounter.confidence >= 0.90 {
            return Color(red: 0.561, green: 0.659, blue: 0.533)
        } else if visionCounter.confidence >= 0.75 {
            return Color(red: 0.83, green: 0.69, blue: 0.22)
        } else {
            return Color(red: 0.79, green: 0.43, blue: 0.37)
        }
    }
    
    private func saveSettings() {
        var newConfig = visionCounter.config
        newConfig.motionThreshold = Float(motionThreshold)
        newConfig.debounceInterval = debounceInterval
        newConfig.confidenceThreshold = Float(confidenceThreshold)
        newConfig.isLeftHanded = isLeftHanded
        
        visionCounter.updateConfig(newConfig)
        
        // Save to UserDefaults
        UserDefaults.standard.set(motionThreshold, forKey: "visionMotionThreshold")
        UserDefaults.standard.set(debounceInterval, forKey: "visionDebounceInterval")
        UserDefaults.standard.set(confidenceThreshold, forKey: "visionConfidenceThreshold")
        UserDefaults.standard.set(isLeftHanded, forKey: "visionIsLeftHanded")
    }
}
