import SwiftUI
import SwiftData

/// 主界面视图
///
/// 用户选择专注时长并开始专注的入口界面
struct HomeView: View {
    @StateObject private var viewModel: TimerViewModel
    @Environment(\.modelContext) private var modelContext

    @State private var navigateToFocus = false

    init(viewModel: TimerViewModel = TimerViewModel(modelContext: .init())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 32) {
            // 标题区域
            headerSection

            Spacer()

            // 时长选择器
            durationPickerSection

            // 开始按钮
            startButton

            Spacer()
                .frame(height: 40)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color.appBackground)
        .navigationDestination(isPresented: $navigateToFocus) {
            FocusView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.syncBackgroundTime()
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Forest Focus")
                .appTitleFont()
                .foregroundColor(Color.appPrimaryText)

            Text("选择专注时长，开始植树")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
        }
    }

    private var durationPickerSection: some View {
        VStack(spacing: 16) {
            Text("专注时长")
                .appSubtitleFont()
                .foregroundColor(Color.appPrimaryText)

            HStack(spacing: 12) {
                ForEach([15, 25, 45, 60], id: \.self) { minutes in
                    DurationButton(
                        minutes: minutes,
                        isSelected: viewModel.selectedDuration == minutes
                    ) {
                        viewModel.selectDuration(minutes)
                    }
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }

    private var startButton: some View {
        Button(action: {
            viewModel.startFocus()
            navigateToFocus = true
        }) {
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.title2.weight(.semibold))
                Text("开始植树")
                    .appButtonFont()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.appPrimary)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .accessibilityButton(
            label: AccessibilityLabels.startButton,
            hint: AccessibilityLabels.startButtonDescription
        )
        .disabled(viewModel.state != .idle)
    }
}

// MARK: - Duration Button

struct DurationButton: View {
    let minutes: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(minutes)分钟")
                .appBodyFont()
                .foregroundColor(isSelected ? .white : Color.appPrimaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(isSelected ? Color.appPrimary : Color.appCardBackground)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.appPrimary : Color.appSecondaryText.opacity(0.3), lineWidth: 1)
                )
        }
        .accessibilityButton(
            label: "\(minutes) 分钟",
            hint: isSelected ? "已选择" : "点击选择\(minutes)分钟专注时长"
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(for: [FocusSession.self, Tree.self], inMemory: true)
}
