import Foundation
import Combine

/// Time period for analytics filtering
enum AnalyticsPeriod: String, CaseIterable {
    case sevenDays = "7 Days"
    case thirtyDays = "30 Days"
    case ninetyDays = "90 Days"
    case allTime = "All Time"

    var days: Int? {
        switch self {
        case .sevenDays: return 7
        case .thirtyDays: return 30
        case .ninetyDays: return 90
        case .allTime: return nil
        }
    }
}

/// Daily statistics for charts
struct DailyStats: Identifiable {
    let id = UUID()
    let date: Date
    let rows: Int
    let time: TimeInterval
    let sessions: Int
}

/// Weekly aggregated statistics
struct WeeklyStats: Identifiable {
    let id = UUID()
    let weekStart: Date
    let rows: Int
    let time: TimeInterval
    let averageRowsPerSession: Double
}

/// AnalyticsService calculates and manages all user statistics
class AnalyticsService: ObservableObject {
    static let shared = AnalyticsService()

    // MARK: - Published Stats

    @Published var totalRows: Int = 0
    @Published var totalTime: TimeInterval = 0
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var completedProjects: Int = 0
    @Published var totalProjects: Int = 0
    @Published var averageRowsPerSession: Double = 0
    @Published var averageTimePerSession: TimeInterval = 0
    @Published var peakHour: Int? = nil
    @Published var speedTrend: [Double] = []

    @Published var dailyStats: [DailyStats] = []
    @Published var weeklyStats: [WeeklyStats] = []
    @Published var selectedPeriod: AnalyticsPeriod = .thirtyDays

    @Published var isLoading: Bool = false
    @Published var lastUpdated: Date?

    private var cancellables = Set<AnyCancellable>()
    private let db = DatabaseManager.shared
    private let isoFormatter = ISO8601DateFormatter()

    private init() {
        // Refresh stats when period changes
        $selectedPeriod
            .sink { [weak self] _ in
                self?.refreshStats()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    /// Refresh all statistics from DatabaseManager
    func refreshStats() {
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.calculateAllStats()

            DispatchQueue.main.async {
                self?.isLoading = false
                self?.lastUpdated = Date()
            }
        }
    }

    // MARK: - Private Calculation Methods

    private func calculateAllStats() {
        let sessions = db.getAllSessions()
        let projects = db.getAllProjects()

        calculateTotals(sessions: sessions)
        calculateStreaks(sessions: sessions)
        calculateProjectStats(projects: projects)
        calculateAverages(sessions: sessions)
        calculatePeakHour(sessions: sessions)
        calculateDailyStats(sessions: sessions)
        calculateWeeklyStats(sessions: sessions)
        calculateSpeedTrend(sessions: sessions)
    }

    private func parseDate(_ isoString: String) -> Date? {
        return isoFormatter.date(from: isoString)
    }

    private func calculateTotals(sessions: [SessionModel]) {
        var totalRows = 0
        var totalTime: TimeInterval = 0

        for session in sessions {
            totalRows += session.rowsKnit
            totalTime += Double(session.timeSpent)
        }

        DispatchQueue.main.async {
            self.totalRows = totalRows
            self.totalTime = totalTime
        }
    }

    private func calculateStreaks(sessions: [SessionModel]) {
        guard !sessions.isEmpty else {
            DispatchQueue.main.async {
                self.currentStreak = 0
                self.longestStreak = 0
            }
            return
        }

        // Group sessions by day
        let calendar = Calendar.current
        var daysWithSessions = Set<Date>()

        for session in sessions {
            if let date = parseDate(session.startTime) {
                let dayStart = calendar.startOfDay(for: date)
                daysWithSessions.insert(dayStart)
            }
        }

        let sortedDays = daysWithSessions.sorted(by: >)

        // Calculate current streak
        var currentStreak = 0
        let today = calendar.startOfDay(for: Date())
        var checkDate = today

        // Check if there's activity today or yesterday
        if !sortedDays.contains(today) {
            checkDate = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        }

        for day in sortedDays {
            if calendar.isDate(day, inSameDayAs: checkDate) {
                currentStreak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else if day < checkDate {
                break
            }
        }

        // Calculate longest streak
        var longestStreak = 0
        var tempStreak = 1

        for i in 1..<sortedDays.count {
            let prevDay = sortedDays[i - 1]
            let currentDay = sortedDays[i]

            if let dayBefore = calendar.date(byAdding: .day, value: -1, to: prevDay),
               calendar.isDate(currentDay, inSameDayAs: dayBefore) {
                tempStreak += 1
            } else {
                longestStreak = max(longestStreak, tempStreak)
                tempStreak = 1
            }
        }
        longestStreak = max(longestStreak, tempStreak)

        DispatchQueue.main.async {
            self.currentStreak = currentStreak
            self.longestStreak = longestStreak
        }
    }

    private func calculateProjectStats(projects: [ProjectModel]) {
        var completed = 0
        for project in projects {
            if project.status == "completed" {
                completed += 1
            }
        }

        DispatchQueue.main.async {
            self.completedProjects = completed
            self.totalProjects = projects.count
        }
    }

    private func calculateAverages(sessions: [SessionModel]) {
        guard !sessions.isEmpty else {
            DispatchQueue.main.async {
                self.averageRowsPerSession = 0
                self.averageTimePerSession = 0
            }
            return
        }

        let totalRows = sessions.reduce(0) { $0 + $1.rowsKnit }
        let totalTime = sessions.reduce(0.0) { $0 + Double($1.timeSpent) }
        let count = Double(sessions.count)

        DispatchQueue.main.async {
            self.averageRowsPerSession = Double(totalRows) / count
            self.averageTimePerSession = totalTime / count
        }
    }

    private func calculatePeakHour(sessions: [SessionModel]) {
        var hourCounts = [Int: Int]()

        for session in sessions {
            if let date = parseDate(session.startTime) {
                let hour = Calendar.current.component(.hour, from: date)
                hourCounts[hour, default: 0] += 1
            }
        }

        let peakHour = hourCounts.max(by: { $0.value < $1.value })?.key

        DispatchQueue.main.async {
            self.peakHour = peakHour
        }
    }

    private func calculateDailyStats(sessions: [SessionModel]) {
        let calendar = Calendar.current
        let now = Date()
        var startDate = now

        if let days = selectedPeriod.days {
            startDate = calendar.date(byAdding: .day, value: -days, to: now) ?? now
        } else {
            // All time - find earliest session
            if let earliest = sessions.compactMap({ parseDate($0.startTime) }).min() {
                startDate = earliest
            }
        }

        // Group sessions by day
        var dailyData = [Date: (rows: Int, time: TimeInterval, count: Int)]()

        for session in sessions {
            guard let date = parseDate(session.startTime), date >= startDate else { continue }
            let dayStart = calendar.startOfDay(for: date)

            var existing = dailyData[dayStart, default: (0, 0, 0)]
            existing.rows += session.rowsKnit
            existing.time += Double(session.timeSpent)
            existing.count += 1
            dailyData[dayStart] = existing
        }

        // Convert to array and sort
        let stats = dailyData.map { date, data in
            DailyStats(date: date, rows: data.rows, time: data.time, sessions: data.count)
        }.sorted(by: { $0.date < $1.date })

        DispatchQueue.main.async {
            self.dailyStats = stats
        }
    }

    private func calculateWeeklyStats(sessions: [SessionModel]) {
        let calendar = Calendar.current
        var weeklyData = [Date: (rows: Int, time: TimeInterval, sessions: Int)]()

        for session in sessions {
            guard let date = parseDate(session.startTime) else { continue }

            // Get start of week
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
            guard let weekStart = calendar.date(from: components) else { continue }

            var existing = weeklyData[weekStart, default: (0, 0, 0)]
            existing.rows += session.rowsKnit
            existing.time += Double(session.timeSpent)
            existing.sessions += 1
            weeklyData[weekStart] = existing
        }

        // Convert to array and sort
        let stats = weeklyData.map { weekStart, data in
            WeeklyStats(
                weekStart: weekStart,
                rows: data.rows,
                time: data.time,
                averageRowsPerSession: data.sessions > 0 ? Double(data.rows) / Double(data.sessions) : 0
            )
        }.sorted(by: { $0.weekStart < $1.weekStart })

        DispatchQueue.main.async {
            self.weeklyStats = stats
        }
    }

    private func calculateSpeedTrend(sessions: [SessionModel]) {
        // Calculate rows per hour for each session (last 30 sessions)
        let recentSessions = sessions
            .sorted { (parseDate($0.startTime) ?? Date.distantPast) > (parseDate($1.startTime) ?? Date.distantPast) }
            .prefix(30)

        let trend = recentSessions.compactMap { session -> Double? in
            let timeSpent = Double(session.timeSpent)
            guard timeSpent > 0 else { return nil }
            return (Double(session.rowsKnit) / timeSpent) * 3600 // Rows per hour
        }.reversed()

        DispatchQueue.main.async {
            self.speedTrend = Array(trend)
        }
    }

    // MARK: - Formatted Values

    var formattedTotalTime: String {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }

    var formattedAverageTime: String {
        let minutes = Int(averageTimePerSession) / 60
        return "\(minutes) min"
    }

    var formattedPeakHour: String {
        guard let hour = peakHour else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }

    private let calendar = Calendar.current

    // MARK: - Completion Rate

    var completionRate: Double {
        guard totalProjects > 0 else { return 0 }
        return Double(completedProjects) / Double(totalProjects) * 100
    }
}
