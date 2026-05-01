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
                    if analyticsService.totalRows > 0 || analyticsService.completedProjects > 0 {
                        InsightsSection()
                    }

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
                    Button(action: { appState.goBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ThemeColors.primary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if analyticsService.isLoading {
                        ProgressView()
                            .tint(ThemeColors.primary)
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
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ?
                                    ThemeColors.primaryGradient :
                                    LinearGradient(colors: [ThemeColors.surface], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(selectedPeriod == period ? .white : ThemeColors.textSecondary)
                        .cornerRadius(20)
                        .shadow(selectedPeriod == period ?
                                Color.black.opacity(0.1) : Color.clear, radius: 4, x: 0, y: 2)
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
        if analyticsService.totalRows == 0 && analyticsService.completedProjects == 0 {
            HStack(spacing: 12) {
                Image(systemName: "chart.bar")
                    .foregroundColor(ThemeColors.textSecondary)
                Text("Start tracking projects to see your stats here")
                    .font(.subheadline)
                    .foregroundColor(ThemeColors.textSecondary)
                Spacer()
            }
            .padding(16)
            .background(ThemeColors.surface)
            .cornerRadius(12)
        }

        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCardView(
                title: "Total Rows",
                value: analyticsService.totalRows == 0 ? "—" : "\(analyticsService.totalRows)",
                icon: "checkmark.circle.fill",
                color: ThemeColors.primary
            )

            StatCardView(
                title: "Time Crafting",
                value: analyticsService.formattedTotalTime == "0 min" ? "—" : analyticsService.formattedTotalTime,
                icon: "clock.fill",
                color: ThemeColors.accent
            )

            StatCardView(
                title: "Current Streak",
                value: analyticsService.currentStreak == 0 ? "—" : "\(analyticsService.currentStreak) days",
                icon: "flame.fill",
                color: ThemeColors.warmGold
            )

            StatCardView(
                title: "Projects Done",
                value: analyticsService.completedProjects == 0 ? "—" : "\(analyticsService.completedProjects)",
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
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(ThemeColors.textPrimary)

                if analyticsService.dailyStats.isEmpty {
                    EmptyChartView(message: "No data yet — complete some rows to see your progress")
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
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(ThemeColors.textPrimary)

                if analyticsService.weeklyStats.isEmpty {
                    EmptyChartView(message: "No data yet — complete some rows to see your progress")
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
                            .font(.system(size: 18, weight: .bold, design: .rounded))
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
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(ThemeColors.textPrimary)

            VStack(spacing: 12) {
                InsightRowView(
                    icon: "chart.pie.fill",
                    title: "Completion Rate",
                    value: String(format: "%.1f%%", analyticsService.completionRate),
                    color: ThemeColors.primary
                )

                InsightRowView(
                    icon: "timer",
                    title: "Avg. Session Time",
                    value: analyticsService.formattedAverageTime,
                    color: ThemeColors.accent
                )

                InsightRowView(
                    icon: "sun.max.fill",
                    title: "Peak Productivity",
                    value: analyticsService.formattedPeakHour,
                    color: ThemeColors.warmGold
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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Next to Unlock")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(ThemeColors.textPrimary)

            VStack(spacing: 12) {
                ForEach(achievementService.achievements.prefix(3)) { achievement in
                    HStack(spacing: 16) {
                        Text(achievement.icon)
                            .font(.system(size: 28))
                            .opacity(achievement.isUnlocked ? 1.0 : 0.6)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(achievement.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(ThemeColors.textPrimary)
                            Text(achievement.description)
                                .font(.caption)
                                .foregroundColor(ThemeColors.textSecondary)
                        }

                        Spacer()

                        if achievement.isUnlocked {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ThemeColors.primary)
                        }
                    }
                    .padding(12)
                    .background(ThemeColors.surface)
                    .cornerRadius(12)
                }
            }

            if achievementService.achievements.count > 3 {
                Button(action: { }) {
                    Text("View all \(achievementService.totalCount) achievements")
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(ThemeColors.primary)
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
                          ThemeColors.primaryLight :
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
