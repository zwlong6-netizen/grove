import SwiftUI

/// 树木详情弹窗视图
///
/// 显示单棵树木的详细信息
struct TreeDetailView: View {
    let tree: Tree

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // 关闭按钮
            closeButton

            Spacer()

            // 树木图标
            completedTreeIcon

            Spacer()

            // 详情信息
            detailInfo

            Spacer()

            // 完成状态
            completionBadge
        }
        .padding(32)
        .background(Color.appCardBackground)
        .cornerRadius(24)
        .padding(.horizontal, 40)
    }

    // MARK: - Subviews

    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(Color.appSecondaryText)
        }
        .accessibilityButton(label: "关闭按钮")
    }

    private var completedTreeIcon: some View {
        ZStack {
            Circle()
                .fill(Color.appPrimary.opacity(0.2))
                .frame(width: 120, height: 120)

            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.appPrimary)
        }
    }

    private var detailInfo: some View {
        VStack(spacing: 20) {
            // 种植日期
            DetailRow(
                icon: "calendar",
                label: "种植日期",
                value: tree.plantedDate.formatted(date: .long, time: .standard)
            )

            Divider()
                .background(Color.appSecondaryText.opacity(0.2))

            // 专注时长
            DetailRow(
                icon: "clock.fill",
                label: "专注时长",
                value: formatDuration(tree.durationSeconds)
            )

            Divider()
                .background(Color.appSecondaryText.opacity(0.2))

            // 生长阶段
            DetailRow(
                icon: "leaf.arrow.circle",
                label: "生长阶段",
                value: "成熟树"
            )
        }
    }

    private var completionBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)

            Text("专注完成!")
                .appBodyFont()
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.green.opacity(0.1))
        .cornerRadius(20)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 {
            return "\(hours)小时\(remainingMinutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }
}

// MARK: - Detail Row Component

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            // 图标
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color.appPrimary)
                .frame(width: 30)

            // 标签
            Text(label)
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 值
            Text(value)
                .appBodyFont()
                .fontWeight(.semibold)
                .foregroundColor(Color.appPrimaryText)
        }
    }
}

// MARK: - Preview

#Preview("树木详情") {
    TreeDetailView(
        tree: Tree(
            plantedDate: Date(),
            durationSeconds: 25 * 60,
            treeStage: 4
        )
    )
}
