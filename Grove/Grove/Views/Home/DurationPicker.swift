import SwiftUI

/// 时长选择器组件
///
/// 提供预设时长选项供用户选择
struct DurationPicker: View {
    /// 可选时长选项（分钟）
    private let options: [Int]
    /// 当前选中的时长
    @Binding var selectedDuration: Int
    /// 时长选择回调
    var onDurationSelected: ((Int) -> Void)?

    init(
        options: [Int] = [15, 25, 45, 60],
        selectedDuration: Binding<Int>,
        onDurationSelected: ((Int) -> Void)? = nil
    ) {
        self.options = options
        self._selectedDuration = selectedDuration
        self.onDurationSelected = onDurationSelected
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("专注时长")
                .appSubtitleFont()
                .foregroundColor(Color.appPrimaryText)

            durationButtons
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }

    private var durationButtons: some View {
        HStack(spacing: 12) {
            ForEach(options, id: \.self) { minutes in
                DurationButton(
                    minutes: minutes,
                    isSelected: selectedDuration == minutes
                ) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedDuration = minutes
                    }
                    onDurationSelected?(minutes)
                }
            }
        }
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
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : Color.appPrimaryText)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(isSelected ? Color.appPrimary : Color.clear)
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
        .accessibility(addTraits: isSelected ? .isSelected : .isButton)
    }
}

// MARK: - Preview

#Preview {
    struct DurationPickerPreview: View {
        @State private var selectedDuration = 25

        var body: some View {
            VStack {
                DurationPicker(
                    selectedDuration: $selectedDuration
                )
            }
            .padding()
            .background(Color.appBackground)
        }
    }

    return DurationPickerPreview()
}
