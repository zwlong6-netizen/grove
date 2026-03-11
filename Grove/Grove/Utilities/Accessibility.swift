import SwiftUI

// MARK: - VoiceOver 无障碍访问基础框架

/// 无障碍访问标签定义
///
/// 为所有核心 UI 元素提供统一的 VoiceOver 标签
struct AccessibilityLabels {
    // MARK: - HomeView

    static let homeView = "主界面"
    static let durationPicker = "时长选择器"
    static let startButton = "开始植树按钮"
    static let startButtonDescription = "点击开始专注时段"

    // MARK: - FocusView

    static let focusView = "专注界面"
    static let treeGrowthView = "树木生长视图"
    static let countdownTimer = "倒计时"
    static let pauseButton = "暂停按钮"
    static let resumeButton = "恢复按钮"
    static let abandonButton = "放弃按钮"
    static let abandonButtonDescription = "点击放弃当前专注"

    // MARK: - ForestView

    static let forestView = "森林视图"
    static let treeGrid = "树木网格"
    static let treeItem = "树木项目"
    static let treeDetailView = "树木详情"
    static let deleteButton = "删除按钮"

    // MARK: - StatisticsView

    static let statisticsView = "统计面板"
    static let totalTreesStat = "总树木数统计"
    static let totalTimeStat = "总专注时间统计"
    static let todayCountStat = "今日专注计数"
    static let streakStat = "连胜记录"

    // MARK: - General

    static let settingsButton = "设置按钮"
    static let closeButton = "关闭按钮"
    static let confirmButton = "确认按钮"
    static let cancelButton = "取消按钮"
}

// MARK: - 无障碍访问值定义

/// 无障碍访问状态值
struct AccessibilityValues {
    /// 格式化剩余时间
    static func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes)分\(remainingSeconds)秒"
    }

    /// 格式化树木阶段
    static func treeStage(_ stage: Int) -> String {
        let stages = ["种子", "嫩芽", "幼苗", "青年树", "成熟树"]
        guard stage >= 0 && stage < stages.count else { return "未知阶段" }
        return stages[stage]
    }

    /// 格式化进度百分比
    static func progress(_ percent: Double) -> String {
        return "\(Int(percent * 100))%"
    }

    /// 格式化连胜记录
    static func streak(_ days: Int) -> String {
        return "\(days) 天连胜"
    }
}

// MARK: - View 扩展 - 无障碍访问修饰符

extension View {
    /// 添加标准按钮无障碍访问
    func accessibilityButton(label: String, hint: String? = nil) -> some View {
        self
            .accessibilityRole(.button)
            .accessibilityLabel(label)
            .accessibilityHint(hint)
    }

    /// 添加图像无障碍访问
    func accessibilityImage(label: String, isDecorative: Bool = false) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHidden(isDecorative)
    }

    /// 添加计时器无障碍访问
    func accessibilityTimer(label: String) -> some View {
        self
            .accessibilityRole(.timer)
            .accessibilityLabel(label)
            .accessibilityLiveRegion(.polite)
    }

    /// 添加进度指示器无障碍访问
    func accessibilityProgress(value: Double, total: Double, label: String) -> some View {
        self
            .accessibilityRole(.progressIndicator)
            .accessibilityLabel(label)
            .accessibilityValue("\(Int(value / total * 100))%")
    }

    /// 添加标题无障碍访问
    func accessibilityHeading(_ level: AccessibilityHeadingLevel) -> some View {
        self
            .accessibilityRole(.header)
            .accessibilityHeadingLevel(level)
    }
}

// MARK: - 无障碍通知

/// 发送无障碍通知
struct AccessibilityNotification {
    /// 宣布消息给 VoiceOver 用户
    static func announce(_ message: String, importance: NotificationImportance = .polite) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }

    /// 通知屏幕内容变化
    static func screenChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIAccessibility.post(notification: .screenChanged, argument: nil)
        }
    }

    /// 通知布局变化
    static func layoutChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
        }
    }
}

// MARK: - 无障碍焦点

/// 管理无障碍焦点
struct AccessibilityFocus {
    /// 将焦点移动到指定元素
    static func moveFocus(to element: AccessibilityFocusState) {
        element.focus()
    }
}

/// 无障碍焦点状态包装器
@propertyWrapper
struct AccessibilityFocusState {
    @State private var isFocused = false

    var wrappedValue: Bool {
        get { isFocused }
        set { isFocused = newValue }
    }

    var projectedValue: AccessibilityFocusState { self }

    func focus() {
        isFocused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFocused = false
        }
    }
}

// MARK: - 动态字体支持基础

extension Font {
    /// 支持动态字体的标题字体
    static func dynamicTitle() -> Font {
        .title.weight(.semibold)
    }

    /// 支持动态字体的正文字体
    static func dynamicBody() -> Font {
        .body
    }

    /// 支持动态字体的说明字体
    static func dynamicCaption() -> Font {
        .caption
    }

    /// 支持动态字体的大标题
    static func dynamicLargeTitle() -> Font {
        .largeTitle.weight(.bold)
    }
}
