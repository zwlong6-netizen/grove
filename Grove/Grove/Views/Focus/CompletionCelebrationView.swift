import SwiftUI

/// 完成庆祝界面
///
/// 专注完成后显示庆祝动画和激励信息
struct CompletionCelebrationView: View {
    var onContinue: () -> Void

    @State private var showConfetti = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // 背景
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // 庆祝图标
                celebrationIcon

                Spacer().frame(height: 40)

                // 标题
                Text("恭喜完成!")
                    .appTitleFont()
                    .foregroundColor(Color.appPrimaryText)

                // 副标题
                Text("你已成功种下一棵新的树木\n继续保持专注!")
                    .appBodyFont()
                    .foregroundColor(Color.appSecondaryText)
                    .multilineTextAlignment(.center)

                Spacer().frame(height: 40)

                // 完成按钮
                Button(action: {
                    onContinue()
                }) {
                    HStack {
                        Image(systemName: "leaf.fill")
                        Text("查看森林")
                    }
                    .appButtonFont()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.appPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    // MARK: - Subviews

    private var celebrationIcon: some View {
        ZStack {
            // 光晕背景
            Circle()
                .fill(Color.appPrimary.opacity(0.2))
                .frame(width: 150, height: 150)

            // 主图标
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 70))
                .foregroundColor(Color.appPrimary)
        }
        .scaleEffect(scale)
        .opacity(opacity)
    }

    // MARK: - Animation

    private func startAnimation() {
        // 图标放大淡入
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            scale = 1.0
            opacity = 1.0
        }

        //  confetti 效果 (使用 SF Symbol 的粒子效果)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showConfetti = true
        }
    }
}

// MARK: - Preview

#Preview("完成庆祝") {
    CompletionCelebrationView {
        print("Continue")
    }
}
