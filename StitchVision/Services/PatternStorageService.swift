import Foundation
import UIKit
import Combine

/// Manages persistence of knitting patterns
@MainActor
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

        Task.detached { [weak self] in
            guard let self else { return }
            let savedPatterns = await self.loadPatternsFromDefaults()
            await MainActor.run {
                self.patterns = savedPatterns
                self.isLoading = false
            }
        }
    }

    /// Save a pattern (with Pro limit check)
    /// Returns true if successful, false if limit reached
    @discardableResult
    func savePattern(_ pattern: KnittingPattern) -> Bool {
        let isNew = !patterns.contains { $0.id == pattern.id }

        if isNew && !canAddPattern() {
            errorMessage = "Pattern limit reached. Upgrade to Pro for unlimited patterns."
            return false
        }

        let currentPatterns = self.patterns
        isLoading = true

        Task.detached { [weak self] in
            guard let self else { return }

            var savedPatterns = currentPatterns

            if let index = savedPatterns.firstIndex(where: { $0.id == pattern.id }) {
                savedPatterns[index] = pattern
            } else {
                savedPatterns.append(pattern)
            }

            await self.savePatternsToDefaults(savedPatterns)

            await MainActor.run {
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
        patterns = savedPatterns

        Task.detached { [weak self] in
            guard let self else { return }
            await self.savePatternsToDefaults(savedPatterns)
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

    private nonisolated func loadPatternsFromDefaults() -> [KnittingPattern] {
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

    private nonisolated func savePatternsToDefaults(_ patterns: [KnittingPattern]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(patterns)
            UserDefaults.standard.set(data, forKey: patternsKey)
        } catch {
            print("Failed to encode patterns: \(error)")
        }
    }
}
