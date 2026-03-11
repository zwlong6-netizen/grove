import SwiftUI

/// 暂停菜单视图
///
/// 提供恢复或放弃专注的选项
struct PauseMenu: View {
    var onResume: () -> Void
    var onAbandon: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // 标题
            Text("专注已暂停")
                .appTitleFont()
                .foregroundColor(Color.appPrimaryText)

            Text("选择继续专注或放弃此次植树")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)

            Spacer()
                .frame(height: 32)

            // 恢复按钮
            Button(action: onResume) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("恢复专注")
                }
                .appButtonFont()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.appPrimary)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .accessibilityButton(
                label: "恢复按钮",
                hint: "点击继续专注"
            )

            // 放弃按钮
            Button(action: onAbandon) {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                    Text("放弃植树")
                }
                .appButtonFont()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red.opacity(0.2))
                .foregroundColor(.red)
                .cornerRadius(12)
            }
            .accessibilityButton(
                label: "放弃按钮",
                hint: "点击放弃当前专注"
            )

            // 取消按钮
            Button(action: onDismiss) {
                Text("取消")
                    .appBodyFont()
                    .foregroundColor(Color.appSecondaryText)
            }
            .accessibilityButton(label: "取消按钮")
        }
        .padding(32)
        .background(Color.appCardBackground)
        .cornerRadius(20)
        .padding(.horizontal, 40)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()

        PauseMenu(
            onResume: {},
            onAbandon: {},
            onDismiss: {}
        )
    }
}
