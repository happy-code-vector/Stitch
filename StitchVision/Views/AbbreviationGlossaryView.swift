import SwiftUI

struct Abbreviation: Codable, Identifiable {
    var id: String { abbr }
    let abbr: String
    let full_term: String
    let description: String
    let craft: String // "knitting", "crochet", or "both"

    var craftType: CraftType {
        switch craft.lowercased() {
        case "knitting": return .knitting
        case "crochet": return .crochet
        default: return .both
        }
    }
}

enum CraftType: String, CaseIterable {
    case both = "All"
    case knitting = "Knitting"
    case crochet = "Crochet"
}

class AbbreviationGlossaryService: ObservableObject {
    static let shared = AbbreviationGlossaryService()

    @Published var abbreviations: [Abbreviation] = []
    @Published var isLoading = false

    private init() {
        loadAbbreviations()
    }

    func loadAbbreviations() {
        isLoading = true

        guard let url = Bundle.main.url(forResource: "abbreviations", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load abbreviations.json")
            isLoading = false
            return
        }

        do {
            abbreviations = try JSONDecoder().decode([Abbreviation].self, from: data)
                .sorted { $0.abbr.lowercased() < $1.abbr.lowercased() }
        } catch {
            print("Failed to decode abbreviations: \(error)")
        }

        isLoading = false
    }

    func filter(searchText: String, craftType: CraftType) -> [Abbreviation] {
        abbreviations.filter { abbr in
            let matchesCraft = craftType == .both || abbr.craftType == craftType || abbr.craftType == .both

            let matchesSearch = searchText.isEmpty ||
                abbr.abbr.lowercased().contains(searchText.lowercased()) ||
                abbr.full_term.lowercased().contains(searchText.lowercased())

            return matchesCraft && matchesSearch
        }
    }
}

struct AbbreviationGlossaryView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var service = AbbreviationGlossaryService.shared
    @State private var searchText = ""
    @State private var selectedCraft: CraftType = .both
    @State private var expandedAbbr: Abbreviation?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ThemeColors.textSecondary)

                    TextField("Search abbreviations...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(ThemeColors.textSecondary)
                        }
                    }
                }
                .padding(12)
                .background(ThemeColors.surfaceRaised)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)

                // Craft Type Filter
                Picker("Craft Type", selection: $selectedCraft) {
                    ForEach(CraftType.allCases, id: \.self) { craft in
                        Text(craft.rawValue).tag(craft)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 12)

                // Abbreviations List
                if service.isLoading {
                    ProgressView("Loading...")
                        .frame(maxHeight: .infinity)
                } else if filteredAbbreviations.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(ThemeColors.textSecondary)

                        Text("No abbreviations found")
                            .font(.headline)
                            .foregroundColor(ThemeColors.textSecondary)

                        Text("Try a different search term")
                            .font(.subheadline)
                            .foregroundColor(ThemeColors.textSecondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(filteredAbbreviations) { abbr in
                                AbbreviationRow(
                                    abbreviation: abbr,
                                    isExpanded: expandedAbbr?.id == abbr.id
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        expandedAbbr = expandedAbbr?.id == abbr.id ? nil : abbr
                                    }
                                }

                                if abbr.id != filteredAbbreviations.last?.id {
                                    Divider()
                                        .padding(.leading, 16)
                                }
                            }
                        }
                        .background(ThemeColors.surface)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }
            .background(ThemeColors.background)
            .navigationTitle("Abbreviation Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { appState.goBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                }
            }
        }
    }

    private var filteredAbbreviations: [Abbreviation] {
        service.filter(searchText: searchText, craftType: selectedCraft)
    }
}

struct AbbreviationRow: View {
    let abbreviation: Abbreviation
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Row
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(abbreviation.abbr)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(ThemeColors.textPrimary)

                            CraftBadge(craftType: abbreviation.craftType)
                        }

                        Text(abbreviation.full_term)
                            .font(.subheadline)
                            .foregroundColor(ThemeColors.textSecondary)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ThemeColors.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            // Expanded Description
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .padding(.horizontal, 16)

                    Text(abbreviation.description)
                        .font(.subheadline)
                        .foregroundColor(ThemeColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                }
                .background(ThemeColors.surfaceRaised)
            }
        }
    }
}

struct CraftBadge: View {
    let craftType: CraftType

    var badgeColor: Color {
        switch craftType {
        case .knitting:
            return Color(red: 0.83, green: 0.71, blue: 0.55)  // warm amber/tan
        case .crochet:
            return Color(red: 0.93, green: 0.65, blue: 0.58)  // warm coral/peach
        case .both:
            return Color(red: 0.561, green: 0.659, blue: 0.533)  // sage green (brand color)
        }
    }

    var body: some View {
        Text(craftType == .both ? "Both" : craftType.rawValue)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(badgeColor)
            .cornerRadius(4)
    }
}

#Preview {
    AbbreviationGlossaryView()
}
