import SwiftUI

/// 统计卡片组件
///
/// 统一的统计数据显示卡片样式
struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 12) {
            // 图标
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color.appPrimary)

            // 数值
            Text(value)
                .appStatFont()
                .foregroundColor(Color.appPrimaryText)

            // 标题
            Text(title)
                .appCaptionFont()
                .foregroundColor(Color.appSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Preview

#Preview("统计卡片") {
    VStack(spacing: 16) {
        StatCard(
            title: "总树木",
            value: "42",
            icon: "leaf.fill"
        )

        StatCard(
            title: "总时长",
            value: "8 小时 35 分钟",
            icon: "clock.fill"
        )

        StatCard(
            title: "今日计数",
            value: "3",
            icon: "calendar"
        )
    }
    .padding()
    .background(Color.appBackground)
}
