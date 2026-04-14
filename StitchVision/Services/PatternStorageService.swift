import Foundation
import UIKit

/// Manages persistence of knitting patterns using DatabaseManager (SQLite).
@MainActor
class PatternStorageService: ObservableObject {

    // MARK: - Published Properties

    @Published var patterns: [KnittingPattern] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private let db = DatabaseManager.shared

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

    /// Load all patterns from database
    func loadPatterns() {
        isLoading = true
        errorMessage = nil
        patterns = db.getPatterns()
        isLoading = false
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

        guard db.savePattern(pattern) else {
            errorMessage = "Failed to save pattern."
            return false
        }

        // Update in-memory list
        if let index = patterns.firstIndex(where: { $0.id == pattern.id }) {
            patterns[index] = pattern
        } else {
            patterns.append(pattern)
        }

        return true
    }

    /// Delete a pattern
    func deletePattern(_ patternId: UUID) {
        _ = db.deletePattern(id: patternId)
        patterns.removeAll { $0.id == patternId }
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
}
