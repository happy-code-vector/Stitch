import SwiftUI
import PhotosUI

struct PatternUploadView: View {
    @EnvironmentObject var appState: AppState
    @State private var isUploading = false
    @State private var uploadProgress = 0.0
    @State private var showImportSheet = false

    var body: some View {
        ZStack {
            Color(red: 0.976, green: 0.969, blue: 0.949)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        appState.goBack()
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

                                    Text("Upload any knitting pattern, and our AI will automatically detect rows for easy tracking.")
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
                            // Photo Library / Camera
                            UploadOptionView(
                                icon: "photo.on.rectangle",
                                title: "Import from Photos",
                                description: "Select a pattern image from your library",
                                action: { showImportSheet = true }
                            )

                            // Camera
                            UploadOptionView(
                                icon: "camera",
                                title: "Take Photo of Pattern",
                                description: "Capture printed pattern with your camera",
                                action: { showImportSheet = true }
                            )
                        }

                        // Help Text
                        Text("Supported formats: JPG, PNG. Maximum file size: 10MB.\nAI detection works best with clearly printed patterns.")
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
        .sheet(isPresented: $showImportSheet) {
            PatternImportView(onPatternSaved: { _ in
                appState.goBack()
            })
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
    }
}
