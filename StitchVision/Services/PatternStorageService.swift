import Foundation
import UIKit
import Combine

/// Manages persistence of knitting patterns
class PatternStorageService: ObservableObject {

    // MARK: - Published Properties

    @Published var patterns: [KnittingPattern] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private let patternsKey = "knittingPatterns"
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Singleton

    static let shared = PatternStorageService()

    private init() {
        loadPatterns()
    }

    // MARK: - Public Methods

    /// Check if user can add more patterns
    func canAddPattern() -> Bool {
        let maxPatterns = SubscriptionManager.shared.maxPatterns
        return patterns.count < maxPatterns
    }

    /// Get remaining patterns allowed
    var remainingPatternSlots: Int {
        let maxPatterns = SubscriptionManager.shared.maxPatterns
        return max(0, maxPatterns - patterns.count)
    }

    /// Load all patterns from storage
    func loadPatterns() {
        isLoading = true
        errorMessage = nil

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }

            let savedPatterns = self.loadPatternsFromDefaults()

            DispatchQueue.main.async {
                self.patterns = savedPatterns
                self.isLoading = false
            }
        }
    }

    /// Save a pattern (with Pro limit check)
    /// Returns true if successful, false if limit reached
    @discardableResult
    func savePattern(_ pattern: KnittingPattern) -> Bool {
        // Check if this is a new pattern
        let isNew = !patterns.contains { $0.id == pattern.id }

        if isNew && !canAddPattern() {
            errorMessage = "Pattern limit reached. Upgrade to Pro for unlimited patterns."
            return false
        }

        isLoading = true

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            var savedPatterns = self.patterns

            // Update or add pattern
            if let index = savedPatterns.firstIndex(where: { $0.id == pattern.id }) {
                savedPatterns[index] = pattern
            } else {
                savedPatterns.append(pattern)
            }

            self.savePatternsToDefaults(savedPatterns)

            DispatchQueue.main.async {
                self.patterns = savedPatterns
                self.isLoading = false
            }
        }

        return true
    }

    /// Delete a pattern
    func deletePattern(_ patternId: UUID) {
        var savedPatterns = patterns
        savedPatterns.removeAll { $0.id == patternId }
        savePatternsToDefaults(savedPatterns)

        DispatchQueue.main.async {
            self.patterns = savedPatterns
        }
    }

    /// Get pattern by ID
    func getPattern(byId id: UUID) -> KnittingPattern? {
        return patterns.first { $0.id == id }
    }

    /// Update pattern progress
    func updateProgress(for patternId: UUID, currentRow: Int, completedRows: Set<Int>) {
        guard var pattern = getPattern(byId: patternId) else { return }

        pattern.currentRow = currentRow
        pattern.completedRows = completedRows

        savePattern(pattern)
    }

    // MARK: - Private Methods

    private func loadPatternsFromDefaults() -> [KnittingPattern] {
        guard let data = UserDefaults.standard.data(forKey: patternsKey) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([KnittingPattern].self, from: data)
        } catch {
            print("Failed to decode patterns: \(error)")
            return []
        }
    }

    private func savePatternsToDefaults(_ patterns: [KnittingPattern]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(patterns)
            UserDefaults.standard.set(data, forKey: patternsKey)
        } catch {
            print("Failed to encode patterns: \(error)")
        }
    }
}
