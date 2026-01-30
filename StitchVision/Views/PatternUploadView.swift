import SwiftUI

struct PatternUploadView: View {
    @EnvironmentObject var appState: AppState
    @State private var isUploading = false
    @State private var uploadProgress = 0.0
    
    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.navigateTo(.dashboard)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }
                    
                    Spacer()
                    
                    Text("Upload Pattern")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Spacer()
                    
                    // Spacer for centering
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.clear)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                if isUploading {
                    // Upload Progress
                    VStack(spacing: 32) {
                        Spacer()
                        
                        VStack(spacing: 24) {
                            // Loading animation
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.2),
                                            Color(red: 0.49, green: 0.57, blue: 0.46).opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                                        .rotationEffect(.degrees(uploadProgress * 3.6))
                                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: uploadProgress)
                                )
                            
                            VStack(spacing: 8) {
                                Text("Analyzing Pattern...")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                
                                Text("Our AI is parsing your pattern instructions")
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .multilineTextAlignment(.center)
                            }
                            
                            // Progress Bar
                            VStack(spacing: 8) {
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(red: 0.898, green: 0.898, blue: 0.898))
                                            .frame(height: 8)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(red: 0.561, green: 0.659, blue: 0.533))
                                            .frame(width: geometry.size.width * (uploadProgress / 100), height: 8)
                                            .animation(.easeOut(duration: 0.3), value: uploadProgress)
                                    }
                                }
                                .frame(height: 8)
                                
                                Text("\(Int(uploadProgress))%")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 32)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        VStack(spacing: 32) {
                            // AI Feature Banner
                            VStack(spacing: 16) {
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(.white.opacity(0.2))
                                        .frame(width: 48, height: 48)
                                        .overlay(
                                            Image(systemName: "sparkles")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("AI Pattern Parsing")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Text("Upload any knitting pattern, and our AI will automatically extract row-by-row instructions for easy tracking.")
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white.opacity(0.9))
                                            .lineLimit(nil)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 24)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.561, green: 0.659, blue: 0.533),
                                        Color(red: 0.49, green: 0.57, blue: 0.46)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(24)
                            
                            // Upload Options
                            VStack(spacing: 16) {
                                // PDF Upload
                                UploadOptionView(
                                    icon: "doc.text",
                                    title: "Upload PDF Pattern",
                                    description: "Select a PDF file from your device",
                                    action: simulateUpload
                                )
                                
                                // Photo Upload
                                UploadOptionView(
                                    icon: "camera",
                                    title: "Take Photo of Pattern",
                                    description: "Capture printed pattern with your camera",
                                    action: simulateUpload
                                )
                                
                                // Manual Entry
                                UploadOptionView(
                                    icon: "doc.text.fill",
                                    title: "Type Pattern Manually",
                                    description: "Enter row instructions one by one",
                                    action: {
                                        // Handle manual entry
                                    }
                                )
                            }
                            
                            // Divider
                            HStack {
                                Rectangle()
                                    .fill(Color(red: 0.867, green: 0.867, blue: 0.867))
                                    .frame(height: 1)
                                
                                Text("OR TRY A SAMPLE")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                    .tracking(1)
                                    .padding(.horizontal, 16)
                                
                                Rectangle()
                                    .fill(Color(red: 0.867, green: 0.867, blue: 0.867))
                                    .frame(height: 1)
                            }
                            
                            // Sample Patterns
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Sample Patterns")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                                    .padding(.horizontal, 8)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 8),
                                    GridItem(.flexible(), spacing: 8)
                                ], spacing: 16) {
                                    SamplePatternView(
                                        emoji: "🧣",
                                        name: "Beginner Scarf Pattern",
                                        rows: 80,
                                        difficulty: "Easy",
                                        action: simulateUpload
                                    )
                                    
                                    SamplePatternView(
                                        emoji: "🧢",
                                        name: "Ribbed Beanie",
                                        rows: 60,
                                        difficulty: "Easy",
                                        action: simulateUpload
                                    )
                                    
                                    SamplePatternView(
                                        emoji: "🛏️",
                                        name: "Cable Knit Blanket",
                                        rows: 200,
                                        difficulty: "Intermediate",
                                        action: simulateUpload
                                    )
                                    
                                    SamplePatternView(
                                        emoji: "🧶",
                                        name: "Lace Shawl",
                                        rows: 120,
                                        difficulty: "Advanced",
                                        action: simulateUpload
                                    )
                                }
                            }
                            
                            // Help Text
                            Text("Supported formats: PDF, JPG, PNG. Maximum file size: 10MB.\nAI parsing works best with clearly printed or typed patterns.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 16)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                    }
                }
            }
        }
        .onAppear {
            uploadProgress = 0
        }
    }
    
    private func simulateUpload() {
        isUploading = true
        uploadProgress = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            uploadProgress += 10
            
            if uploadProgress >= 100 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appState.navigateTo(.patternVerification)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct UploadOptionView: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.1))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                    
                    Text(description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: title)
    }
}

struct SamplePatternView: View {
    let emoji: String
    let name: String
    let rows: Int
    let difficulty: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.2),
                                Color(red: 0.49, green: 0.57, blue: 0.46).opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(emoji)
                            .font(.title2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text("\(rows) rows")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        Text("•")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        
                        Text(difficulty)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: name)
    }
}