import SwiftUI
import Charts

struct AnalyticsView: View {
    @StateObject private var analyticsService = AnalyticsService.shared
    @StateObject private var achievementService = AchievementService.shared
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Period Selector
                    PeriodSelectorView(selectedPeriod: $analyticsService.selectedPeriod)

                    // Overview Cards
                    OverviewCardsSection()

                    // Charts Section
                    ChartsSection()

                    // Insights Section
                    InsightsSection()

                    // Achievements Section
                    AchievementsSection()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            .background(ThemeColors.background)
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        appState.goBack()
                    }
                    .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if analyticsService.isLoading {
                        ProgressView()
                            .tint(Color(red: 0.561, green: 0.659, blue: 0.533))
                    }
                }
            }
        }
        .onAppear {
            analyticsService.refreshStats()
        }
    }
}

// MARK: - Period Selector

struct PeriodSelectorView: View {
    @Binding var selectedPeriod: AnalyticsPeriod

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ?
                                    ThemeColors.primary :
                                    ThemeColors.surface)
                        .foregroundColor(selectedPeriod == period ? .white : ThemeColors.textSecondary)
                        .cornerRadius(20)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Overview Cards Section

struct OverviewCardsSection: View {
    @ObservedObject var analyticsService = AnalyticsService.shared

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCardView(
                title: "Total Rows",
                value: "\(analyticsService.totalRows)",
                icon: "checkmark.circle.fill",
                color: Color(red: 0.561, green: 0.659, blue: 0.533)
            )

            StatCardView(
                title: "Time Knitting",
                value: analyticsService.formattedTotalTime,
                icon: "clock.fill",
                color: Color(red: 0.831, green: 0.502, blue: 0.435)
            )

            StatCardView(
                title: "Current Streak",
                value: "\(analyticsService.currentStreak) days",
                icon: "flame.fill",
                color: Color(red: 0.949, green: 0.631, blue: 0.286)
            )

            StatCardView(
                title: "Projects Done",
                value: "\(analyticsService.completedProjects)",
                icon: "checkmark.seal.fill",
                color: Color(red: 0.4, green: 0.6, blue: 0.8)
            )
        }
    }
}

// MARK: - Charts Section

struct ChartsSection: View {
    @ObservedObject var analyticsService = AnalyticsService.shared
    @ObservedObject var subscriptionManager = SubscriptionManager.shared

    var body: some View {
        VStack(spacing: 20) {
            // Rows Over Time Chart
            VStack(alignment: .leading, spacing: 12) {
                Text("Rows Over Time")
                    .font(.headline)
                    .foregroundColor(ThemeColors.textPrimary)

                if analyticsService.dailyStats.isEmpty {
                    EmptyChartView(message: "No data yet. Start knitting!")
                } else {
                    RowTrendChart(stats: analyticsService.dailyStats)
                        .frame(height: 200)
                        .background(ThemeColors.surface)
                        .cornerRadius(16)
                }
            }

            // Weekly Summary
            VStack(alignment: .leading, spacing: 12) {
                Text("Weekly Summary")
                    .font(.headline)
                    .foregroundColor(ThemeColors.textPrimary)

                if analyticsService.weeklyStats.isEmpty {
                    EmptyChartView(message: "No weekly data yet")
                } else {
                    WeeklyBarChart(stats: Array(analyticsService.weeklyStats.suffix(8)))
                        .frame(height: 180)
                        .background(ThemeColors.surface)
                        .cornerRadius(16)
                }
            }

            // Speed Trend (Pro Feature)
            if subscriptionManager.isPro {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Speed Trend")
                            .font(.headline)
                            .foregroundColor(ThemeColors.textPrimary)

                        Spacer()

                        ProBadgeView()
                    }

                    if analyticsService.speedTrend.isEmpty {
                        EmptyChartView(message: "Complete more sessions to see your speed trend")
                    } else {
                        SpeedTrendChart(trend: analyticsService.speedTrend)
                            .frame(height: 150)
                            .background(ThemeColors.surface)
                            .cornerRadius(16)
                    }
                }
            }
        }
    }
}

// MARK: - Insights Section

struct InsightsSection: View {
    @ObservedObject var analyticsService = AnalyticsService.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.headline)
                .foregroundColor(ThemeColors.textPrimary)

            VStack(spacing: 12) {
                InsightRowView(
                    icon: "chart.pie.fill",
                    title: "Completion Rate",
                    value: String(format: "%.1f%%", analyticsService.completionRate),
                    color: Color(red: 0.561, green: 0.659, blue: 0.533)
                )

                InsightRowView(
                    icon: "timer",
                    title: "Avg. Session Time",
                    value: analyticsService.formattedAverageTime,
                    color: Color(red: 0.831, green: 0.502, blue: 0.435)
                )

                InsightRowView(
                    icon: "sun.max.fill",
                    title: "Peak Productivity",
                    value: analyticsService.formattedPeakHour,
                    color: Color(red: 0.949, green: 0.631, blue: 0.286)
                )

                InsightRowView(
                    icon: "arrow.up.right",
                    title: "Avg. Rows/Session",
                    value: String(format: "%.1f", analyticsService.averageRowsPerSession),
                    color: Color(red: 0.4, green: 0.6, blue: 0.8)
                )
            }
            .padding(16)
            .background(ThemeColors.surface)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Achievements Section

struct AchievementsSection: View {
    @ObservedObject var achievementService = AchievementService.shared
    @ObservedObject var subscriptionManager = SubscriptionManager.shared

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                    .foregroundColor(ThemeColors.textPrimary)

                Spacer()

                Text("\(achievementService.unlockedCount)/\(achievementService.totalCount)")
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.textSecondary)
            }

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(achievementService.achievements.prefix(12)) { achievement in
                    AchievementBadgeView(achievement: achievement)
                }
            }

            // Show more button if there are more achievements
            if achievementService.achievements.count > 12 {
                Button(action: {
                    // Navigate to full achievements view
                }) {
                    Text("View All Achievements")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.561, green: 0.659, blue: 0.533))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(ThemeColors.surface)
                        .cornerRadius(12)
                }
            }
        }
    }
}

// MARK: - Achievement Badge View

struct AchievementBadgeView: View {
    let achievement: Achievement
    @ObservedObject var subscriptionManager = SubscriptionManager.shared

    var isAccessible: Bool {
        !achievement.isProOnly || subscriptionManager.isPro
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ?
                          Color(red: 0.561, green: 0.659, blue: 0.533).opacity(0.2) :
                          ThemeColors.surfaceRaised)
                    .frame(width: 60, height: 60)

                Text(achievement.icon)
                    .font(.system(size: 28))
                    .opacity(achievement.isUnlocked ? 1 : 0.4)
                    .grayscale(achievement.isUnlocked ? 0 : 1)

                if !isAccessible {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(ThemeColors.textSecondary)
                        .clipShape(Circle())
                        .offset(x: 20, y: 20)
                }
            }

            Text(achievement.title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(achievement.isUnlocked ?
                                  ThemeColors.textPrimary :
                                  ThemeColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Empty Chart View

struct EmptyChartView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.system(size: 40))
                .foregroundColor(ThemeColors.border)

            Text(message)
                .font(.subheadline)
                .foregroundColor(ThemeColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(ThemeColors.surface)
        .cornerRadius(16)
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(AppState())
}
