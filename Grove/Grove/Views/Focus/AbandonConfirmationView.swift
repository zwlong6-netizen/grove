import SwiftUI

/// 放弃确认弹窗视图
///
/// 用户确认是否要放弃当前专注
struct AbandonConfirmationView: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // 图标
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            // 标题
            Text("确定要放弃吗？")
                .appTitleFont()
                .foregroundColor(Color.appPrimaryText)

            // 说明文字
            Text("放弃后，这棵树将被摧毁\n且不会记录到森林中")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
                .multilineTextAlignment(.center)

            Spacer()
                .frame(height: 24)

            // 确认放弃按钮
            Button(action: onConfirm) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("确认放弃")
                }
                .appButtonFont()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .accessibilityButton(
                label: "确认放弃按钮",
                hint: "点击确认放弃当前专注"
            )

            // 取消按钮
            Button(action: onCancel) {
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

        AbandonConfirmationView(
            onConfirm: {},
            onCancel: {}
        )
    }
}
