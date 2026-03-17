import SwiftUI
import Charts

// MARK: - Stat Card View

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)

                Spacer()
            }

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))

            Text(title)
                .font(.caption)
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Row Trend Chart

struct RowTrendChart: View {
    let stats: [DailyStats]

    var body: some View {
        Chart(stats) { stat in
            BarMark(
                x: .value("Date", stat.date, unit: .day),
                y: .value("Rows", stat.rows)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.561, green: 0.659, blue: 0.533),
                        Color(red: 0.49, green: 0.57, blue: 0.46)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(4)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 7)) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(formatDate(date))
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
            }
        }
        .chartYAxisLabel("Rows")
        .padding()
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Weekly Bar Chart

struct WeeklyBarChart: View {
    let stats: [WeeklyStats]

    var body: some View {
        Chart(stats) { stat in
            BarMark(
                x: .value("Week", formatWeek(stat.weekStart)),
                y: .value("Rows", stat.rows)
            )
            .foregroundStyle(Color(red: 0.4, green: 0.6, blue: 0.8))
            .cornerRadius(4)
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let weekString = value.as(String.self) {
                        Text(weekString)
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
            }
        }
        .chartYAxisLabel("Rows")
        .padding()
    }

    private func formatWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "w"
        return "W\(formatter.string(from: date))"
    }
}

// MARK: - Speed Trend Chart

struct SpeedTrendChart: View {
    let trend: [Double]

    var body: some View {
        Chart(Array(trend.enumerated()), id: \.offset) { index, speed in
            LineMark(
                x: .value("Session", index),
                y: .value("Rows/Hour", speed)
            )
            .foregroundStyle(Color(red: 0.949, green: 0.631, blue: 0.286))
            .lineStyle(StrokeStyle(lineWidth: 2))

            AreaMark(
                x: .value("Session", index),
                y: .value("Rows/Hour", speed)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.949, green: 0.631, blue: 0.286).opacity(0.3),
                        Color(red: 0.949, green: 0.631, blue: 0.286).opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .font(.caption2)
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    }
                }
            }
        }
        .chartYAxisLabel("Rows/Hour")
        .padding()
    }
}

// MARK: - Insight Row View

struct InsightRowView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))

                Text(value)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.173, green: 0.173, blue: 0.173))
            }

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        StatCardView(
            title: "Total Rows",
            value: "1,234",
            icon: "checkmark.circle.fill",
            color: Color(red: 0.561, green: 0.659, blue: 0.533)
        )

        RowTrendChart(stats: [
            DailyStats(date: Date(), rows: 50, time: 3600, sessions: 2),
            DailyStats(date: Date().addingTimeInterval(-86400), rows: 75, time: 5400, sessions: 3),
            DailyStats(date: Date().addingTimeInterval(-172800), rows: 30, time: 1800, sessions: 1)
        ])
        .frame(height: 200)
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }
    .padding()
    .background(Color(red: 0.976, green: 0.969, blue: 0.949))
}
