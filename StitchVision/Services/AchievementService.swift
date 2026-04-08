import Foundation
import Combine

/// Achievement definition
struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let category: AchievementCategory
    let requirement: AchievementRequirement
    let isProOnly: Bool

    var isUnlocked: Bool = false
    var unlockedDate: Date?
}

enum AchievementCategory: String, Codable {
    case rows = "Rows"
    case streaks = "Streaks"
    case projects = "Projects"
    case patterns = "Patterns"
    case time = "Time"
    case special = "Special"
}

enum AchievementRequirement: Codable {
    case totalRows(Int)
    case streakDays(Int)
    case completedProjects(Int)
    case importedPatterns(Int)
    case totalHours(Int)
    case rowsInSession(Int)
    case sessionsAtHour(Int, Int) // count, hour
    case sessionCount(Int)
}

/// Service for tracking and unlocking achievements
class AchievementService: ObservableObject {
    static let shared = AchievementService()

    @Published var achievements: [Achievement] = []
    @Published var recentlyUnlocked: Achievement?
    @Published var showUnlockNotification: Bool = false

    private let unlockedKey = "unlockedAchievements"

    // MARK: - All Achievements Definition

    private let allAchievements: [Achievement] = [
        // Row achievements
        Achievement(
            id: "first_row",
            title: "First Stitch",
            description: "Complete your first row",
            icon: "🧵",
            category: .rows,
            requirement: .totalRows(1),
            isProOnly: false
        ),
        Achievement(
            id: "100_rows",
            title: "100 Club",
            description: "Knit 100 rows total",
            icon: "💯",
            category: .rows,
            requirement: .totalRows(100),
            isProOnly: false
        ),
        Achievement(
            id: "1000_rows",
            title: "1000 Club",
            description: "Knit 1,000 rows total",
            icon: "🎯",
            category: .rows,
            requirement: .totalRows(1000),
            isProOnly: false
        ),
        Achievement(
            id: "5000_rows",
            title: "Row Master",
            description: "Knit 5,000 rows total",
            icon: "👑",
            category: .rows,
            requirement: .totalRows(5000),
            isProOnly: true
        ),
        Achievement(
            id: "speed_demon",
            title: "Speed Demon",
            description: "Knit 100+ rows in a single session",
            icon: "⚡",
            category: .rows,
            requirement: .rowsInSession(100),
            isProOnly: true
        ),

        // Streak achievements
        Achievement(
            id: "3_day_streak",
            title: "Getting Started",
            description: "Maintain a 3-day streak",
            icon: "🔥",
            category: .streaks,
            requirement: .streakDays(3),
            isProOnly: false
        ),
        Achievement(
            id: "7_day_streak",
            title: "Week Warrior",
            description: "Maintain a 7-day streak",
            icon: "🗓️",
            category: .streaks,
            requirement: .streakDays(7),
            isProOnly: false
        ),
        Achievement(
            id: "30_day_streak",
            title: "Month Master",
            description: "Maintain a 30-day streak",
            icon: "🏆",
            category: .streaks,
            requirement: .streakDays(30),
            isProOnly: true
        ),
        Achievement(
            id: "100_day_streak",
            title: "Centurion",
            description: "Maintain a 100-day streak",
            icon: "🌟",
            category: .streaks,
            requirement: .streakDays(100),
            isProOnly: true
        ),

        // Project achievements
        Achievement(
            id: "first_project",
            title: "Project Complete",
            description: "Complete your first project",
            icon: "✨",
            category: .projects,
            requirement: .completedProjects(1),
            isProOnly: false
        ),
        Achievement(
            id: "5_projects",
            title: "Prolific Creator",
            description: "Complete 5 projects",
            icon: "🎨",
            category: .projects,
            requirement: .completedProjects(5),
            isProOnly: true
        ),
        Achievement(
            id: "10_projects",
            title: "Master Crafter",
            description: "Complete 10 projects",
            icon: "🎖️",
            category: .projects,
            requirement: .completedProjects(10),
            isProOnly: true
        ),

        // Pattern achievements
        Achievement(
            id: "first_pattern",
            title: "Pattern Collector",
            description: "Import your first pattern",
            icon: "📄",
            category: .patterns,
            requirement: .importedPatterns(1),
            isProOnly: false
        ),
        Achievement(
            id: "5_patterns",
            title: "Pattern Library",
            description: "Import 5 patterns",
            icon: "📚",
            category: .patterns,
            requirement: .importedPatterns(5),
            isProOnly: true
        ),
        Achievement(
            id: "10_patterns",
            title: "Pattern Master",
            description: "Import 10 patterns",
            icon: "🗂️",
            category: .patterns,
            requirement: .importedPatterns(10),
            isProOnly: true
        ),

        // Time achievements
        Achievement(
            id: "1_hour",
            title: "Dedicated",
            description: "Spend 1 hour knitting",
            icon: "⏰",
            category: .time,
            requirement: .totalHours(1),
            isProOnly: false
        ),
        Achievement(
            id: "10_hours",
            title: "Committed",
            description: "Spend 10 hours knitting",
            icon: "⏱️",
            category: .time,
            requirement: .totalHours(10),
            isProOnly: false
        ),
        Achievement(
            id: "100_hours",
            title: "Devoted",
            description: "Spend 100 hours knitting",
            icon: "⌛",
            category: .time,
            requirement: .totalHours(100),
            isProOnly: true
        ),

        // Special achievements
        Achievement(
            id: "night_owl",
            title: "Night Owl",
            description: "Complete 10 sessions after 10 PM",
            icon: "🦉",
            category: .special,
            requirement: .sessionsAtHour(10, 22),
            isProOnly: true
        ),
        Achievement(
            id: "early_bird",
            title: "Early Bird",
            description: "Complete 10 sessions before 8 AM",
            icon: "🐦",
            category: .special,
            requirement: .sessionsAtHour(10, 8),
            isProOnly: true
        ),
        Achievement(
            id: "10_sessions",
            title: "Regular",
            description: "Complete 10 knitting sessions",
            icon: "✅",
            category: .special,
            requirement: .sessionCount(10),
            isProOnly: false
        ),
        Achievement(
            id: "50_sessions",
            title: "Enthusiast",
            description: "Complete 50 knitting sessions",
            icon: "🌟",
            category: .special,
            requirement: .sessionCount(50),
            isProOnly: true
        ),
    ]

    private init() {
        loadUnlockedAchievements()
    }

    // MARK: - Public Methods

    /// Check all achievements against current stats
    func checkAchievements(
        totalRows: Int,
        currentStreak: Int,
        completedProjects: Int,
        totalHours: Double,
        patternCount: Int,
        sessions: [SessionModel],
        isPro: Bool
    ) {
        var newUnlocks: [Achievement] = []

        for var achievement in allAchievements {
            if achievement.isUnlocked { continue }
            if achievement.isProOnly && !isPro { continue }

            let shouldUnlock = checkRequirement(
                achievement.requirement,
                totalRows: totalRows,
                currentStreak: currentStreak,
                completedProjects: completedProjects,
                totalHours: totalHours,
                patternCount: patternCount,
                sessions: sessions
            )

            if shouldUnlock {
                achievement.isUnlocked = true
                achievement.unlockedDate = Date()
                newUnlocks.append(achievement)
            }
        }

        if let first = newUnlocks.first {
            DispatchQueue.main.async {
                self.recentlyUnlocked = first
                self.showUnlockNotification = true
            }
        }

        saveUnlockedAchievements()
        updatePublishedAchievements()
    }

    /// Get achievements filtered by category
    func achievements(for category: AchievementCategory) -> [Achievement] {
        achievements.filter { $0.category == category }
    }

    /// Get unlocked achievements count
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }

    /// Get total achievements count (including Pro-locked)
    var totalCount: Int {
        allAchievements.count
    }

    // MARK: - Private Methods

    private func checkRequirement(
        _ requirement: AchievementRequirement,
        totalRows: Int,
        currentStreak: Int,
        completedProjects: Int,
        totalHours: Double,
        patternCount: Int,
        sessions: [SessionModel]
    ) -> Bool {
        let isoFormatter = ISO8601DateFormatter()

        switch requirement {
        case .totalRows(let count):
            return totalRows >= count

        case .streakDays(let days):
            return currentStreak >= days

        case .completedProjects(let count):
            return completedProjects >= count

        case .importedPatterns(let count):
            return patternCount >= count

        case .totalHours(let hours):
            return Int(totalHours) >= hours

        case .rowsInSession(let count):
            return sessions.contains { $0.rowsKnit >= count }

        case .sessionsAtHour(let requiredCount, let targetHour):
            let matchingSessions = sessions.filter { session in
                guard let date = isoFormatter.date(from: session.startTime) else { return false }
                let hour = Calendar.current.component(.hour, from: date)
                return hour >= targetHour && hour < targetHour + 1
            }
            return matchingSessions.count >= requiredCount

        case .sessionCount(let count):
            return sessions.count >= count
        }
    }

    private func loadUnlockedAchievements() {
        guard let data = UserDefaults.standard.data(forKey: unlockedKey),
              let unlockedIds = try? JSONDecoder().decode(Set<String>.self, from: data) else {
            achievements = allAchievements
            return
        }

        achievements = allAchievements.map { achievement in
            var modified = achievement
            if unlockedIds.contains(achievement.id) {
                modified.isUnlocked = true
            }
            return modified
        }
    }

    private func saveUnlockedAchievements() {
        let unlockedIds = Set(achievements.filter { $0.isUnlocked }.map { $0.id })

        if let data = try? JSONEncoder().encode(unlockedIds) {
            UserDefaults.standard.set(data, forKey: unlockedKey)
        }
    }

    private func updatePublishedAchievements() {
        let unlockedIds = achievements.filter { $0.isUnlocked }.map { $0.id }

        achievements = allAchievements.map { achievement in
            var modified = achievement
            modified.isUnlocked = unlockedIds.contains(achievement.id)
            return modified
        }
    }
}
