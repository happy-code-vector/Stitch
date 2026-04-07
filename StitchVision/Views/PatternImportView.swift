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
    @State private var patternName = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var loadImageTask: Task<Void, Never>?
    @State private var detectRowsTask: Task<Void, Never>?

    var onPatternSaved: ((KnittingPattern) -> Void)? = nil

    var body: some View {
        NavigationStack {
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
            .navigationTitle("Import Pattern")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                loadImageTask?.cancel()
                detectRowsTask?.cancel()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        savePattern()
                    }
                    .disabled(isLoading || selectedImage == nil || detectionResult == nil)
                }
            }
        }
    }

    private var imagePickerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 60))
                .foregroundStyle(.gray)

            Text("Import Pattern")
                .font(.title2)
                .fontWeight(.bold)

            Text("Select a pattern image from your photo library to track your progress")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("Choose from Photos")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .clipShape(.rect(cornerRadius: 12))
            }
            .onChange(of: selectedItem) { _, newItem in
                loadImage(from: newItem)
            }
        }
    }

    private var imagePreviewSection: some View {
        VStack(spacing: 16) {
            // Image preview — only shown when selectedImage is non-nil
            Image(uiImage: selectedImage!)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .clipShape(.rect(cornerRadius: 12))

            // Pattern name input
            VStack(alignment: .leading) {
                Text("Pattern Name")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("Enter pattern name", text: $patternName)
                    .textFieldStyle(.roundedBorder)
            }

            // Detect button
            Button(action: detectRows) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Image(systemName: "wand.and.stars")
                    }
                    Text("Detect Rows")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 12))
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
                .foregroundStyle(.green)

            Text("Pattern Detected")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 4) {
                Text("\(result.totalRows) rows detected")
                    .font(.headline)

                Text("Confidence: \(Int(result.confidence * 100))%")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.orange)

            Text("Detection Issue")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }

        // Fix 10: Clear the previous image immediately so the UI doesn't show
        // a stale image while the new one loads.
        selectedImage = nil
        detectionResult = nil
        errorMessage = nil
        isLoading = true

        // Fix 12: Cancel any in-flight load before starting a new one.
        loadImageTask?.cancel()
        loadImageTask = Task {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    guard !Task.isCancelled else { return }
                    selectedImage = uiImage
                    isLoading = false
                } else {
                    guard !Task.isCancelled else { return }
                    isLoading = false
                    errorMessage = "Failed to load image"
                }
            } catch {
                guard !Task.isCancelled else { return }
                isLoading = false
                errorMessage = "Failed to load image: \(error.localizedDescription)"
            }
        }
    }

    private func detectRows() {
        guard let image = selectedImage else { return }

        isLoading = true
        errorMessage = nil

        // Fix 12: Cancel any in-flight detection before starting a new one.
        detectRowsTask?.cancel()
        detectRowsTask = Task {
            // Fix 4 & 11: Use a proper async wrapper so all state mutations
            // happen after the await, on the main actor, with no loose
            // trailing work after continuation.resume().
            let result = await withCheckedContinuation { (continuation: CheckedContinuation<PatternDetectionResult, Never>) in
                detectionService.detectRows(in: image) { result in
                    continuation.resume(returning: result)
                }
            }

            guard !Task.isCancelled else { return }

            detectionResult = result
            isLoading = false

            if result.isSuccess && patternName.isEmpty {
                patternName = "Pattern (\(result.totalRows) rows)"
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

        let saved = storageService.savePattern(pattern)
        guard saved else {
            errorMessage = storageService.errorMessage ?? "Failed to save pattern."
            return
        }
        onPatternSaved?(pattern)
        dismiss()
    }
}
