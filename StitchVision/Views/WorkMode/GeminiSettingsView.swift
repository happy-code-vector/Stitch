import SwiftUI

struct GeminiSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var geminiService: GeminiVisionService
    
    @State private var analysisInterval: Double = 3.0
    @State private var apiKey: String = ""
    
    init(geminiService: GeminiVisionService) {
        self.geminiService = geminiService
        _analysisInterval = State(initialValue: UserDefaults.standard.double(forKey: "geminiAnalysisInterval") > 0 ? UserDefaults.standard.double(forKey: "geminiAnalysisInterval") : 3.0)
        _apiKey = State(initialValue: UserDefaults.standard.string(forKey: "geminiApiKey") ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Configuration")) {
                    TextField("Gemini API Key", text: $apiKey)
                        .textContentType(.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                    
                    Link("Get API Key", destination: URL(string: "https://makersuite.google.com/app/apikey")!)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Section(header: Text("Analysis Settings")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Analysis Interval")
                            Spacer()
                            Text(String(format: "%.1fs", analysisInterval))
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $analysisInterval, in: 1.0...10.0, step: 0.5)
                        Text("How often to send frames to Gemini API")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Current Status")) {
                    HStack {
                        Text("Row Count")
                        Spacer()
                        Text("\(geminiService.currentCount)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Confidence")
                        Spacer()
                        Text("\(Int(geminiService.confidence * 100))%")
                            .foregroundColor(confidenceColor)
                    }
                    
                    HStack {
                        Text("Status")
                        Spacer()
                        if geminiService.isAnalyzing {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Analyzing")
                            }
                        } else {
                            Text("Ready")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let lastAnalysis = geminiService.lastAnalysisTime {
                        HStack {
                            Text("Last Analysis")
                            Spacer()
                            Text(timeAgo(lastAnalysis))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        geminiService.resetCount()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Count")
                        }
                        .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("About")) {
                    Text("StitchVision uses Google Gemini AI to analyze your knitting in real-time. Images are sent to Google's servers for processing.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Gemini Settings")
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                hideKeyboard()
            }
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
        if geminiService.confidence >= 0.90 {
            return Color(red: 0.561, green: 0.659, blue: 0.533)
        } else if geminiService.confidence >= 0.75 {
            return Color(red: 0.83, green: 0.69, blue: 0.22)
        } else {
            return Color(red: 0.79, green: 0.43, blue: 0.37)
        }
    }
    
    private func saveSettings() {
        geminiService.setAnalysisInterval(analysisInterval)
        geminiService.updateApiKey(apiKey)
        UserDefaults.standard.set(analysisInterval, forKey: "geminiAnalysisInterval")
        UserDefaults.standard.set(apiKey, forKey: "geminiApiKey")
    }
    
    private func timeAgo(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 {
            return "\(seconds)s ago"
        } else {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
