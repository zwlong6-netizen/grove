import SwiftUI
import SwiftData

/// 统计面板视图
///
/// 显示用户的专注统计数据
struct StatisticsView: View {
    @Query(filter: #Predicate<FocusSession> { $0.status == .completed })
    var completedSessions: [FocusSession]

    @State private var todayCount: Int = 0
    @State private var currentStreak: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 标题
                titleSection

                Spacer().frame(height: 16)

                // 统计卡片网格
                statisticsGrid

                Spacer().frame(height: 24)

                // 连胜记录卡片
                StreakCard(streak: currentStreak)

                Spacer().frame(height: 32)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.appBackground)
            .onAppear {
                computeStatistics()
            }
        }
    }

    // MARK: - Subviews

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("统计数据")
                .appTitleFont()
                .foregroundColor(Color.appPrimaryText)

            Text("追踪你的专注历程")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
        }
    }

    private var statisticsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 16
        ) {
            StatCard(
                title: "总树木",
                value: "\(completedSessions.count)",
                icon: "leaf.fill"
            )

            StatCard(
                title: "今日计数",
                value: "\(todayCount)",
                icon: "calendar"
            )

            StatCard(
                title: "总时长",
                value: formattedTotalTime,
                icon: "clock.fill"
            )

            StatCard(
                title: "平均时长",
                value: formattedAverageTime,
                icon: "chart.bar.fill"
            )
        }
    }

    // MARK: - Computed Properties

    private var formattedTotalTime: String {
        let totalSeconds = completedSessions.reduce(0) { $0 + $1.actualElapsedTimeSeconds }
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60

        if hours > 0 {
            return "\(hours)小时\(minutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }

    private var formattedAverageTime: String {
        guard !completedSessions.isEmpty else { return "0 分钟" }

        let totalSeconds = completedSessions.reduce(0) { $0 + $1.actualElapsedTimeSeconds }
        let averageMinutes = totalSeconds / completedSessions.count / 60
        return "\(averageMinutes)分钟"
    }

    // MARK: - Methods

    private func computeStatistics() {
        // 今日计数
        todayCount = completedSessions.filter {
            Calendar.current.isDateInToday($0.startTime)
        }.count

        // 连胜记录
        currentStreak = calculateStreak()
    }

    private func calculateStreak() -> Int {
        guard !completedSessions.isEmpty else { return 0 }

        let calendar = Calendar.current
        let sortedDates = completedSessions
            .compactMap { $0.endTime }
            .sorted(by: >)

        var streak = 0
        var currentDate = Date()

        for date in sortedDates {
            if calendar.isDate(date, equalTo: currentDate, toGranularity: .day) {
                continue
            }

            if calendar.isDate(date, equalTo: currentDate, toGranularity: .day, in: .backward) {
                streak += 1
                currentDate = date
            } else {
                break
            }
        }

        return streak
    }
}

// MARK: - Preview

#Preview("统计面板") {
    NavigationStack {
        StatisticsView()
    }
    .modelContainer(for: [FocusSession.self, Tree.self], inMemory: true)
}
