import Foundation
import UIKit

// MARK: - Starter Pattern Model

struct StarterPattern: Codable, Identifiable {
    let id: String
    let title: String
    let difficulty: String
    let category: String
    let craftType: String
    let estimatedHours: Int
    let yarnWeight: String?
    let needleSize: String?
    let hookSize: String?
    let gauge: String?
    let sourceCredit: String?
    let tags: [String]
    let isFeatured: Bool
    let supportsRounds: Bool
    let steps: [StarterStep]

    enum CodingKeys: String, CodingKey {
        case id, title, difficulty, category
        case craftType = "craft_type"
        case estimatedHours = "estimated_hours"
        case yarnWeight = "yarn_weight"
        case needleSize = "needle_size"
        case hookSize = "hook_size"
        case gauge
        case sourceCredit = "source_credit"
        case tags
        case isFeatured = "is_featured"
        case supportsRounds = "supports_rounds"
        case steps
    }
}

struct StarterStep: Codable {
    let row: Int
    let text: String
    let type: String
    let isRound: Bool

    enum CodingKeys: String, CodingKey {
        case row, text, type
        case isRound = "is_round"
    }
}

// MARK: - Starter Library Service

@MainActor
class StarterLibraryService: ObservableObject {
    static let shared = StarterLibraryService()

    @Published var patterns: [StarterPattern] = []
    @Published var categories: [String] = []
    @Published var isLoading = false

    private init() {
        loadPatterns()
    }

    func loadPatterns() {
        isLoading = true
        defer { isLoading = false }

        guard let url = Bundle.main.url(forResource: "starter_library", withExtension: "json", subdirectory: "Data") else {
            // Try without subdirectory
            guard let url = Bundle.main.url(forResource: "starter_library", withExtension: "json") else {
                return
            }
            loadFromURL(url)
            return
        }
        loadFromURL(url)
    }

    private func loadFromURL(_ url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([StarterPattern].self, from: data)
            patterns = decoded
            categories = Array(Set(decoded.map(\.category))).sorted()
        } catch {
            print("Failed to load starter library: \(error)")
        }
    }

    func patterns(for category: String) -> [StarterPattern] {
        patterns.filter { $0.category == category }
    }

    func featuredPatterns() -> [StarterPattern] {
        patterns.filter(\.isFeatured)
    }

    func search(_ query: String) -> [StarterPattern] {
        guard !query.isEmpty else { return patterns }
        let lowered = query.lowercased()
        return patterns.filter {
            $0.title.lowercased().contains(lowered) ||
            $0.tags.contains(where: { $0.lowercased().contains(lowered) }) ||
            $0.category.lowercased().contains(lowered) ||
            $0.difficulty.lowercased().contains(lowered)
        }
    }

    var categoryEmoji: [String: String] {
        [
            "Scarves & Cowls": "🧣",
            "Hats & Beanies": "🧢",
            "Baby Items": "👶",
            "Dishcloths & Squares": "🧽",
            "Mittens & Gloves": "🧤",
            "Socks": "🧦",
            "Shawls": "🪄",
            "Amigurumi": "🧸",
            "Home Decor": "🏠",
            "Blankets": "🛏️"
        ]
    }
}
