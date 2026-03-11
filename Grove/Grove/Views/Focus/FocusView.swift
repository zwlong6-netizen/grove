import SwiftUI
import SwiftData

/// 专注中界面视图
///
/// 显示倒计时、树木生长状态，提供暂停和放弃功能
struct FocusView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showPauseMenu = false
    @State private var showAbandonConfirm = false

    var body: some View {
        VStack(spacing: 24) {
            // 导航栏
            navigationBar

            Spacer()

            // 树木生长视图
            TreeGrowthView(stage: viewModel.currentStage, progress: viewModel.progress)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)

            Spacer()

            // 计时器显示
            timerDisplay

            // 控制按钮
            controlButtons
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(Color.appBackground)
        .sheet(isPresented: $showPauseMenu) {
            PauseMenu(
                onResume: {
                    viewModel.resumeFocus()
                    showPauseMenu = false
                },
                onAbandon: {
                    viewModel.abandonFocus()
                    showPauseMenu = false
                    dismiss()
                },
                onDismiss: {
                    showPauseMenu = false
                }
            )
        }
        .sheet(isPresented: $showAbandonConfirm) {
            AbandonConfirmationView(
                onConfirm: {
                    viewModel.abandonFocus()
                    showAbandonConfirm = false
                    dismiss()
                },
                onCancel: {
                    showAbandonConfirm = false
                }
            )
        }
        .onAppear {
            viewModel.syncBackgroundTime()
        }
    }

    // MARK: - Subviews

    private var navigationBar: some View {
        HStack {
            Text("专注中")
                .appSubtitleFont()
                .foregroundColor(Color.appPrimaryText)

            Spacer()
        }
        .padding(.top, 8)
    }

    private var timerDisplay: some View {
        VStack(spacing: 8) {
            Text(viewModel.formattedRemainingTime)
                .font(.system(size: 56, weight: .light, design: .rounded))
                .foregroundColor(Color.appPrimaryText)
                .monospacedDigit()
                .accessibilityTimer(label: "剩余时间 \(viewModel.formattedRemainingTime)")

            Text(viewModel.currentTreeStage.description)
                .appCaptionFont()
                .foregroundColor(Color.appSecondaryText)
        }
    }

    private var controlButtons: some View {
        HStack(spacing: 16) {
            // 暂停按钮
            Button(action: {
                if viewModel.isPaused {
                    viewModel.resumeFocus()
                } else {
                    viewModel.pauseFocus()
                    showPauseMenu = true
                }
            }) {
                HStack {
                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                    Text(viewModel.isPaused ? "恢复" : "暂停")
                }
                .appButtonFont()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.appSecondaryText.opacity(0.2))
                .foregroundColor(Color.appPrimaryText)
                .cornerRadius(12)
            }
            .accessibilityButton(label: viewModel.isPaused ? "恢复按钮" : "暂停按钮")

            // 放弃按钮
            Button(action: {
                showAbandonConfirm = true
            }) {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                    Text("放弃")
                }
                .appButtonFont()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red.opacity(0.2))
                .foregroundColor(.red)
                .cornerRadius(12)
            }
            .accessibilityButton(
                label: "放弃按钮",
                hint: "点击放弃当前专注"
            )
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FocusView(viewModel: TimerViewModel(modelContext: .init()))
    }
    .modelContainer(for: [FocusSession.self, Tree.self], inMemory: true)
}
