import SwiftUI

/// 连胜记录卡片
///
/// 显示用户连续专注的天数
struct StreakCard: View {
    let streak: Int

    var body: some View {
        VStack(spacing: 20) {
            // 火焰图标
            flameIcon

            // 标题
            Text("当前连胜")
                .appSubtitleFont()
                .foregroundColor(Color.appPrimaryText)

            // 天数显示
            VStack(spacing: 8) {
                Text("\(streak)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(Color.appPrimary)

                Text("天")
                    .appBodyFont()
                    .foregroundColor(Color.appSecondaryText)
            }

            // 提示信息
            if streak > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .font(.caption)
                    Text("保持下去!")
                        .appCaptionFont()
                }
                .foregroundColor(.orange)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            } else {
                Text("开始第一次专注来建立连胜")
                    .appCaptionFont()
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(Color.appCardBackground)
        .cornerRadius(20)
    }

    private var flameIcon: some View {
        ZStack {
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 80, height: 80)

            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
        }
    }
}

// MARK: - Preview

#Preview("连胜卡片") {
    VStack(spacing: 16) {
        StreakCard(streak: 7)
        StreakCard(streak: 0)
        StreakCard(streak: 30)
    }
    .padding()
    .background(Color.appBackground)
}
