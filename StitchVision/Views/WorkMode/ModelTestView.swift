import SwiftUI

struct ModelTestView: View {
    @StateObject private var classifier = CoreMLStitchClassifier()
    @State private var testResult: String = "Not tested yet"
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Model Status
                VStack(spacing: 12) {
                    Image(systemName: classifier.modelLoaded ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(classifier.modelLoaded ? .green : .orange)
                    
                    Text(classifier.getModelInfo())
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    if !classifier.modelLoaded {
                        Text("Model will use rule-based classification")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Divider()
                
                // Test Results
                VStack(alignment: .leading, spacing: 12) {
                    Text("Last Classification:")
                        .font(.headline)
                    
                    if let classification = classifier.lastClassification {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Type:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(classification.motionType.rawValue)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Is Knitting:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(classification.isKnittingMotion ? "Yes ✅" : "No ❌")
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Confidence:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(Int(classification.confidence * 100))%")
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    } else {
                        Text("No classification yet")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                Spacer()
                
                // Instructions
                VStack(alignment: .leading, spacing: 8) {
                    Text("How to Add Model:")
                        .font(.headline)
                    
                    Text("1. Create or download StitchClassifier.mlmodel")
                        .font(.caption)
                    Text("2. Drag it into Xcode project")
                        .font(.caption)
                    Text("3. Check 'Copy items if needed'")
                        .font(.caption)
                    Text("4. Rebuild the app")
                        .font(.caption)
                    Text("5. Model will load automatically")
                        .font(.caption)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                
                // Test Button
                Button(action: runTest) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "play.circle.fill")
                        }
                        Text(isLoading ? "Testing..." : "Run Test")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .cornerRadius(12)
                }
                .disabled(isLoading)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Model Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func runTest() {
        isLoading = true
        testResult = "Testing model..."
        
        // Simulate processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Create a dummy pixel buffer for testing
            if let testBuffer = createTestPixelBuffer() {
                classifier.processFrame(testBuffer)
            }
            
            isLoading = false
            testResult = "Test completed"
        }
    }
    
    private func createTestPixelBuffer() -> CVPixelBuffer? {
        let width = 640
        let height = 480
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            nil,
            &pixelBuffer
        )
        
        return status == kCVReturnSuccess ? pixelBuffer : nil
    }
}

struct ModelTestView_Previews: PreviewProvider {
    static var previews: some View {
        ModelTestView()
    }
}
