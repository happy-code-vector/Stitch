import SwiftUI

struct PatternLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storageService = PatternStorageService.shared
    @StateObject private var starterLibrary = StarterLibraryService.shared
    @State private var showImportSheet = false
    @State private var patternToDelete: KnittingPattern?
    @State private var showDeleteConfirmation = false
    @State private var selectedTab: PatternTab = .starter

    enum PatternTab: String, CaseIterable {
        case starter = "Starter Library"
        case myPatterns = "My Patterns"
    }

    let onPatternSelected: ((KnittingPattern) -> Void)?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Picker
                Picker("Library", selection: $selectedTab) {
                    ForEach(PatternTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                if selectedTab == .starter {
                    starterLibraryView
                } else {
                    myPatternsView
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
                    selectedTab = .myPatterns
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

    // MARK: - Starter Library View

    private var starterLibraryView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // Featured patterns
                let featured = starterLibrary.featuredPatterns()
                if !featured.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured")
                            .font(.headline)
                            .foregroundColor(ThemeColors.textPrimary)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(featured) { pattern in
                                    StarterPatternCard(pattern: pattern) {
                                        selectStarterPattern(pattern)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }

                // By Category
                ForEach(starterLibrary.categories, id: \.self) { category in
                    let patterns = starterLibrary.patterns(for: category)
                    if !patterns.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Text(starterLibrary.categoryEmoji[category] ?? "🧶")
                                Text(category)
                                    .font(.headline)
                                    .foregroundColor(ThemeColors.textPrimary)
                            }
                            .padding(.horizontal, 16)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(patterns) { pattern in
                                        StarterPatternCard(pattern: pattern) {
                                            selectStarterPattern(pattern)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - My Patterns View

    private var myPatternsView: some View {
        Group {
            if storageService.patterns.isEmpty && !storageService.isLoading {
                myPatternsEmptyState
            } else {
                myPatternsGrid
            }
        }
    }

    private var myPatternsEmptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 60))
                .foregroundColor(ThemeColors.textSecondary)

            Text("No Imported Patterns")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ThemeColors.textPrimary)

            Text("Import your first pattern to track your progress")
                .font(.body)
                .foregroundColor(ThemeColors.textSecondary)
                .multilineTextAlignment(.center)

            Button(action: { showImportSheet = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Import Pattern")
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(ThemeColors.primary)
        }
        .padding()
    }

    private var myPatternsGrid: some View {
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

    // MARK: - Starter Pattern Selection

    private func selectStarterPattern(_ starter: StarterPattern) {
        // Convert starter pattern steps to pattern data for the project
        let stepsData: [[String: Any]] = starter.steps.map { step in
            [
                "row": step.row,
                "text": step.text,
                "type": step.type,
                "isRound": step.isRound
            ]
        }

        // Store the selected pattern info and dismiss
        // The caller (WorkModeView) will handle creating a project from it
        NotificationCenter.default.post(
            name: .starterPatternSelected,
            object: nil,
            userInfo: [
                "patternId": starter.id,
                "title": starter.title,
                "totalRows": starter.steps.count,
                "craftType": starter.craftType,
                "supportsRounds": starter.supportsRounds,
                "steps": stepsData
            ]
        )
        dismiss()
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let starterPatternSelected = Notification.Name("starterPatternSelected")
}

// MARK: - Starter Pattern Card

struct StarterPatternCard: View {
    let pattern: StarterPattern
    let onSelect: () -> Void

    private var emoji: String {
        let type = pattern.category.lowercased()
        if type.contains("scarf") || type.contains("cowl") { return "🧣" }
        if type.contains("hat") || type.contains("beanie") { return "🧢" }
        if type.contains("baby") { return "👶" }
        if type.contains("dishcloth") || type.contains("square") { return "🧽" }
        if type.contains("mitten") || type.contains("glove") { return "🧤" }
        if type.contains("sock") { return "🧦" }
        if type.contains("shawl") { return "🪄" }
        if type.contains("amigurumi") { return "🧸" }
        if type.contains("home") || type.contains("pillow") { return "🏠" }
        if type.contains("blanket") { return "🛏️" }
        return "🧶"
    }

    private var difficultyColor: Color {
        switch pattern.difficulty.lowercased() {
        case "beginner": return ThemeColors.success
        case "easy": return ThemeColors.primary
        case "intermediate": return Color(red: 0.949, green: 0.631, blue: 0.286)
        case "advanced": return ThemeColors.destructive
        default: return ThemeColors.textSecondary
        }
    }

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                // Header with emoji and craft type
                HStack {
                    Text(emoji)
                        .font(.system(size: 32))
                    Spacer()
                    if pattern.isFeatured {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(Color(red: 0.949, green: 0.631, blue: 0.286))
                    }
                }

                Text(pattern.title)
                    .font(.headline)
                    .foregroundColor(ThemeColors.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(pattern.difficulty)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(difficultyColor)
                    }

                    Text("\(pattern.steps.count) steps • ~\(pattern.estimatedHours)h")
                        .font(.caption2)
                        .foregroundColor(ThemeColors.textSecondary)

                    if let yarn = pattern.yarnWeight {
                        Text(yarn.capitalized)
                            .font(.caption2)
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                }

                // Craft type badge
                HStack {
                    Text(pattern.craftType == "knitting" ? "🧶 Knitting" : "🪡 Crochet")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(ThemeColors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(ThemeColors.primary.opacity(0.1))
                        .cornerRadius(8)

                    if pattern.supportsRounds {
                        Text("In the round")
                            .font(.caption2)
                            .foregroundColor(ThemeColors.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(ThemeColors.surfaceRaised)
                            .cornerRadius(6)
                    }
                }
            }
            .padding(12)
            .frame(width: 170)
            .background(ThemeColors.surface)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
                    .background(ThemeColors.primary)
                    .cornerRadius(8)
                    .padding(6)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(pattern.name)
                    .font(.headline)
                    .foregroundColor(ThemeColors.textPrimary)
                    .lineLimit(1)

                Text("\(pattern.totalRows) rows • \(pattern.currentRow) completed")
                    .font(.caption)
                    .foregroundColor(ThemeColors.textSecondary)
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(ThemeColors.surface)
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
