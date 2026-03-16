import SwiftUI

struct PatternLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storageService = PatternStorageService.shared
    @State private var showImportSheet = false
    @State private var patternToDelete: KnittingPattern?
    @State private var showDeleteConfirmation = false

    let onPatternSelected: ((KnittingPattern) -> Void)?

    var body: some View {
        NavigationView {
            Group {
                if storageService.patterns.isEmpty && !storageService.isLoading {
                    emptyStateView
                } else {
                    patternGridView
                }
            }
            .navigationTitle("Pattern Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showImportSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showImportSheet) {
                PatternImportView(onPatternSaved: { pattern in
                    // Pattern is automatically saved by import view
                })
            }
            .alert("Delete Pattern?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {
                    patternToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let pattern = patternToDelete {
                        storageService.deletePattern(pattern.id)
                    }
                    patternToDelete = nil
                }
            } message: {
                if let pattern = patternToDelete {
                    Text("This will permanently delete '\(pattern.name)'. This action cannot be undone.")
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No Patterns")
                .font(.title2)
                .fontWeight(.bold)

            Text("Import your first pattern to track your progress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { showImportSheet = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Import Pattern")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.561, green: 0.659, blue: 0.533))
        }
        .padding()
    }

    private var patternGridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(storageService.patterns) { pattern in
                    PatternCard(
                        pattern: pattern,
                        onSelect: {
                            onPatternSelected?(pattern)
                            dismiss()
                        },
                        onDelete: {
                            patternToDelete = pattern
                            showDeleteConfirmation = true
                        }
                    )
                }
            }
            .padding()
        }
        .overlay {
            if storageService.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}

struct PatternCard: View {
    let pattern: KnittingPattern
    let onSelect: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Pattern thumbnail
            ZStack(alignment: .topTrailing) {
                if let uiImage = UIImage(data: pattern.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                }

                // Progress badge
                Text("\(Int(pattern.progress * 100))%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color(red: 0.561, green: 0.659, blue: 0.533))
                    .cornerRadius(8)
                    .padding(6)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(pattern.name)
                    .font(.headline)
                    .lineLimit(1)

                Text("\(pattern.totalRows) rows • \(pattern.currentRow) completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            onSelect()
        }
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
