import SwiftUI

/// 树木摧毁动画视图
///
/// 当用户放弃专注时显示树木被摧毁的动画
struct TreeDestructionAnimation: View {
    var onComplete: () -> Void

    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var rotation: Double = 0
    @State private var shakeOffset: CGFloat = 0
    @State private var showCracks = false

    var body: some View {
        ZStack {
            // 深色背景蒙版
            Color.black.opacity(opacity * 0.7)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // 摧毁中的树木
                destructionTree

                Spacer().frame(height: 32)

                // 提示信息
                Text("树木已被摧毁")
                    .appTitleFont()
                    .foregroundColor(.white)

                Text("下次加油，重新种下一棵树吧!")
                    .appBodyFont()
                    .foregroundColor(.white.opacity(0.8))

                Spacer().frame(height: 24)

                // 确定按钮
                Button(action: {
                    onComplete()
                }) {
                    Text("知道了")
                        .appButtonFont()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    // MARK: - Subviews

    private var destructionTree: some View {
        ZStack {
            // 枯萎效果
            Circle()
                .fill(Color.brown.opacity(0.5))
                .frame(width: 100 * scale, height: 100 * scale)
                .rotationEffect(.degrees(rotation))
                .offset(x: shakeOffset)
                .opacity(opacity)

            // 裂纹效果
            if showCracks {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 80 * scale))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(rotation))
                    .offset(x: shakeOffset)
                    .opacity(opacity)
            }
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        // 第一阶段：摇晃
        withAnimation(.easeInOut(duration: 0.1)) {
            shakeOffset = 5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = -5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showCracks = true
        }

        // 第二阶段：收缩和变暗
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                scale = 0.3
                opacity = 0
                rotation = 45
            }
        }
    }
}

// MARK: - Preview

#Preview("摧毁动画") {
    TreeDestructionAnimation {
        print("Completed")
    }
}
