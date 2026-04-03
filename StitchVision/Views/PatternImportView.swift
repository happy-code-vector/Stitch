import SwiftUI
import PhotosUI

struct PatternImportView: View {
    @Environment(\.dismiss) private var dismiss
    private let detectionService = PatternDetectionService.shared
    @ObservedObject private var storageService = PatternStorageService.shared

    @State private var selectedImage: UIImage?
    @State private var isLoading = false
    @State private var detectionResult: PatternDetectionResult?
    @State private var errorMessage: String?
    @State private var patternName: String = ""
    @State private var selectedItem: PhotosPickerItem?

    let onPatternSaved: ((KnittingPattern) -> Void)?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if selectedImage == nil {
                        imagePickerSection
                    } else {
                        imagePreviewSection
                        detectionResultSection
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedImage != nil && detectionResult != nil {
                        Button("Save") {
                            if !isLoading {
                                savePattern()
                            }
                        }
                        .disabled(isLoading || detectionResult == nil)
                    }
                }
            }
        }
    }

    private var imagePickerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("Import Pattern")
                .font(.title2)
                .fontWeight(.bold)

            Text("Select a pattern image from your photo library to track your progress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Choose from Photos")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .cornerRadius(12)
            }
            .onChange(of: selectedItem) { newItem in
                loadImage(from: newItem)
            }
        }
    }

    private var imagePreviewSection: some View {
        VStack(spacing: 16) {
            // Image preview
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
            }

            // Pattern name input
            VStack(alignment: .leading) {
                Text("Pattern Name")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("Enter pattern name", text: $patternName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Detect button
            Button(action: detectRows) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Image(systemName: "wand.and.stars")
                    }
                    Text(isLoading ? "Detecting..." : "Detect Rows")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isLoading)
        }
    }

    @ViewBuilder
    private var detectionResultSection: some View {
        if let result = detectionResult {
            if result.isSuccess {
                successView(result)
            } else {
                errorView(result.errorMessage ?? "Detection failed")
            }
        } else if let error = errorMessage {
            errorView(error)
        }
    }

    private func successView(_ result: PatternDetectionResult) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)

            Text("Pattern Detected")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 4) {
                Text("\(result.totalRows) rows detected")
                    .font(.headline)

                Text("Confidence: \(Int(result.confidence * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text("Detection Issue")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }

        isLoading = true

        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    selectedImage = uiImage
                    isLoading = false
                    detectionResult = nil
                    errorMessage = nil
                }
            } else {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Failed to load image"
                }
            }
        }
    }

    private func detectRows() {
        guard let image = selectedImage else { return }

        isLoading = true
        errorMessage = nil

        detectionService.detectRows(in: image) { result in
            detectionResult = result
            isLoading = false

            if result.isSuccess {
                // Auto-fill pattern name if empty
                if patternName.isEmpty {
                    patternName = "Pattern (\(result.totalRows) rows)"
                }
            }
        }
    }

    private func savePattern() {
        guard let image = selectedImage,
              let result = detectionResult,
              result.isSuccess else { return }

        let pattern = KnittingPattern(
            name: patternName.isEmpty ? "Unnamed Pattern" : patternName,
            imageData: image.jpegData(compressionQuality: 0.8) ?? Data(),
            detectedRows: result.rows,
            totalRows: result.totalRows
        )

        storageService.savePattern(pattern)
        onPatternSaved?(pattern)
        dismiss()
    }
}
