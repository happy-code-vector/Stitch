import Foundation
import UIKit
import AVFoundation
import Combine

struct GeminiAnalysisResult {
    let isKnitting: Bool
    let rowCount: Int?
    let confidence: Double
    let message: String
}

class GeminiVisionService: ObservableObject {
    
    @Published var currentCount: Int = 0
    @Published var confidence: Double = 0.0
    @Published var isAnalyzing: Bool = false
    @Published var lastAnalysisTime: Date?
    
    private var apiKey: String
    private var analysisInterval: TimeInterval = 3.0
    private var lastFrameAnalyzed: Date?
    
    private let session: URLSession
    
    init(apiKey: String = "") {
        // Load API key from UserDefaults if not provided
        if apiKey.isEmpty {
            self.apiKey = UserDefaults.standard.string(forKey: "geminiApiKey") ?? ""
        } else {
            self.apiKey = apiKey
        }
        
        // Load analysis interval from UserDefaults
        let savedInterval = UserDefaults.standard.double(forKey: "geminiAnalysisInterval")
        if savedInterval > 0 {
            self.analysisInterval = savedInterval
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Process Frame
    
    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        // Check if enough time has passed since last analysis
        if let lastTime = lastFrameAnalyzed {
            let timeSinceLastAnalysis = Date().timeIntervalSince(lastTime)
            if timeSinceLastAnalysis < analysisInterval {
                return
            }
        }
        
        // Don't analyze if already analyzing
        guard !isAnalyzing else { return }
        
        lastFrameAnalyzed = Date()
        
        // Convert pixel buffer to image
        guard let image = pixelBufferToUIImage(pixelBuffer) else {
            return
        }
        
        // Analyze with Gemini
        analyzeImage(image)
    }
    
    // MARK: - Gemini API Call
    
    private func analyzeImage(_ image: UIImage) {
        isAnalyzing = true
        
        Task {
            do {
                let result = try await sendToGemini(image: image)
                
                await MainActor.run {
                    self.handleAnalysisResult(result)
                    self.isAnalyzing = false
                    self.lastAnalysisTime = Date()
                }
            } catch {
                print("Gemini API error: \(error.localizedDescription)")
                await MainActor.run {
                    self.isAnalyzing = false
                }
            }
        }
    }
    
    private func sendToGemini(image: UIImage) async throws -> GeminiAnalysisResult {
        // Resize image to reduce API payload
        let resizedImage = image.resized(to: CGSize(width: 512, height: 512))
        
        // Convert to base64
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "GeminiVisionService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])
        }
        let base64Image = imageData.base64EncodedString()
        
        // Prepare API request
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        Analyze this image for knitting or crocheting activity. 
        
        Respond in JSON format with:
        {
            "is_knitting": true/false,
            "row_count_visible": number or null,
            "confidence": 0.0-1.0,
            "message": "brief description"
        }
        
        Look for:
        - Yarn or thread visible
        - Knitting needles or crochet hooks
        - Hands performing knitting/crochet motions
        - Fabric being created
        
        If you see active knitting, estimate the number of visible rows if possible.
        """
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.4,
                "topK": 32,
                "topP": 1,
                "maxOutputTokens": 200
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Make request
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "GeminiVisionService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NSError(domain: "GeminiVisionService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "API error: \(httpResponse.statusCode)"])
        }
        
        // Parse response
        return try parseGeminiResponse(data)
    }
    
    private func parseGeminiResponse(_ data: Data) throws -> GeminiAnalysisResult {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let candidates = json?["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw NSError(domain: "GeminiVisionService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])
        }
        
        // Extract JSON from response text
        let jsonText = extractJSON(from: text)
        guard let jsonData = jsonText.data(using: .utf8),
              let analysisJson = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            // Fallback: parse text manually
            return GeminiAnalysisResult(
                isKnitting: text.lowercased().contains("knitting") || text.lowercased().contains("crochet"),
                rowCount: nil,
                confidence: 0.5,
                message: text
            )
        }
        
        let isKnitting = analysisJson["is_knitting"] as? Bool ?? false
        let rowCount = analysisJson["row_count_visible"] as? Int
        let confidence = analysisJson["confidence"] as? Double ?? 0.5
        let message = analysisJson["message"] as? String ?? "Analysis complete"
        
        return GeminiAnalysisResult(
            isKnitting: isKnitting,
            rowCount: rowCount,
            confidence: confidence,
            message: message
        )
    }
    
    private func extractJSON(from text: String) -> String {
        // Try to extract JSON from markdown code blocks
        if let jsonStart = text.range(of: "```json"),
           let jsonEnd = text.range(of: "```", range: jsonStart.upperBound..<text.endIndex) {
            let jsonRange = jsonStart.upperBound..<jsonEnd.lowerBound
            return String(text[jsonRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Try to find JSON object directly
        if let start = text.firstIndex(of: "{"),
           let end = text.lastIndex(of: "}") {
            return String(text[start...end])
        }
        
        return text
    }
    
    // MARK: - Handle Result
    
    private func handleAnalysisResult(_ result: GeminiAnalysisResult) {
        confidence = result.confidence
        
        if result.isKnitting {
            if let detectedRows = result.rowCount {
                // Update count if Gemini detected rows
                if detectedRows > currentCount {
                    currentCount = detectedRows
                    
                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                }
            }
        }
        
        print("Gemini Analysis: \(result.message)")
    }
    
    // MARK: - Manual Controls
    
    func manualIncrement() {
        currentCount += 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func manualDecrement() {
        currentCount = max(0, currentCount - 1)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func resetCount() {
        currentCount = 0
    }
    
    func setAnalysisInterval(_ interval: TimeInterval) {
        analysisInterval = interval
    }
    
    func updateApiKey(_ key: String) {
        apiKey = key
        UserDefaults.standard.set(key, forKey: "geminiApiKey")
    }
    
    // MARK: - Helper Methods
    
    private func pixelBufferToUIImage(_ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - UIImage Extension

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
