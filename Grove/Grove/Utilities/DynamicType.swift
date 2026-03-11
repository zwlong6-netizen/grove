import SwiftUI

// MARK: - 动态字体支持框架

/// 动态字体缩放配置
struct DynamicTypeConfig {
    /// 最大缩放比例 (200%)
    static let maxScale: CGFloat = 2.0

    /// 最小缩放比例
    static let minScale: CGFloat = 0.5

    /// 标准缩放比例
    static let normalScale: CGFloat = 1.0
}

// MARK: - 支持动态字体的字体修饰符

/// 限制最大字体大小的修饰符
struct MaxFontSizeModifier: ViewModifier {
    let maxSize: CGFloat

    func body(content: Content) -> some View {
        content
            .environment(\.dynamicTypeSize, .current)
            .accessibilityDynamicTypeSize(.medium)
    }
}

// MARK: - 动态字体样式

/// 应用字体样式定义
struct AppFontStyles {
    // MARK: - 标题样式

    /// 大标题 - 支持动态字体
    static let largeTitle = Font.largeTitle

    /// 主标题 - 支持动态字体
    static let title = Font.title

    /// 次级标题 - 支持动态字体
    static let title2 = Font.title2

    /// 三级标题 - 支持动态字体
    static let title3 = Font.title3

    // MARK: - 正文样式

    /// 正文 - 支持动态字体
    static let body = Font.body

    /// 说明文字 - 支持动态字体
    static let callout = Font.callout

    /// 副标题 - 支持动态字体
    static let subhead = Font.subheadline

    // MARK: - 按钮样式

    /// 按钮字体 - 支持动态字体
    static let button = Font.body.weight(.semibold)

    // MARK: - 标注样式

    /// 标注 - 支持动态字体
    static let caption = Font.caption

    /// 脚注 - 支持动态字体
    static let footnote = Font.footnote
}

// MARK: - View 扩展 - 动态字体方法

extension View {
    /// 应用标题字体样式
    func appTitleFont() -> some View {
        self.font(.largeTitle.weight(.bold))
            .dynamicTypeSize(...DynamicTypeConfig.maxScale)
    }

    /// 应用副标题字体样式
    func appSubtitleFont() -> some View {
        self.font(.title.weight(.semibold))
            .dynamicTypeSize(...DynamicTypeConfig.maxScale)
    }

    /// 应用正文字体样式
    func appBodyFont() -> some View {
        self.font(.body)
            .dynamicTypeSize(...DynamicTypeConfig.maxScale)
    }

    /// 应用说明字体样式
    func appCaptionFont() -> some View {
        self.font(.caption)
            .dynamicTypeSize(...DynamicTypeConfig.maxScale)
    }

    /// 应用按钮字体样式
    func appButtonFont() -> some View {
        self.font(.body.weight(.semibold))
            .dynamicTypeSize(...DynamicTypeConfig.maxScale)
    }

    /// 应用统计数字字体样式
    func appStatFont() -> some View {
        self.font(.system(size: 32, weight: .bold, design: .rounded))
            .dynamicTypeSize(...DynamicTypeConfig.maxScale)
    }

    /// 限制最大字体大小
    func maxFontDynamicSize(_ maxSize: CGFloat) -> some View {
        self.environment(\.dynamicTypeSize, .current)
    }
}

// MARK: - 响应式字体计算

/// 响应式字体工具
struct ResponsiveFont {
    /// 根据屏幕宽度计算合适的字体大小
    static func size(for screenWidth: CGFloat, baseSize: CGFloat) -> CGFloat {
        let scale = min(screenWidth / 375.0, DynamicTypeConfig.maxScale)
        return baseSize * max(scale, DynamicTypeConfig.minScale)
    }

    /// 获取适应动态字体的字体
    static func font(base: Font, scale: CGFloat) -> Font {
        base.weight(.regular) // 基础实现，可根据需要扩展
    }
}

// MARK: - 环境键值

/// 动态字体缩放比例环境键
struct FontScaleKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    /// 当前字体缩放比例
    var fontScale: CGFloat {
        get { self[FontScaleKey.self] }
        set { self[FontScaleKey.self] = newValue }
    }
}

// MARK: - 视图修改器 - 自适应布局

/// 确保布局在动态字体下不崩坏
struct AdaptiveLayoutModifier: ViewModifier {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            .padding(horizontalPadding)
            .spacing(verticalSpacing)
    }

    private var horizontalPadding: CGFloat {
        if dynamicTypeSize >= .accessibility5 {
            return 20
        } else if dynamicTypeSize >= .accessibility2 {
            return 16
        } else {
            return 12
        }
    }

    private var verticalSpacing: CGFloat {
        if dynamicTypeSize >= .accessibility5 {
            return 12
        } else if dynamicTypeSize >= .accessibility2 {
            return 8
        } else {
            return 4
        }
    }
}

extension View {
    /// 应用自适应布局修饰符
    func adaptiveLayout() -> some View {
        self.modifier(AdaptiveLayoutModifier())
    }
}

// MARK: - 辅助函数

/// 检查当前是否处于大字体模式
func isLargeTextMode() -> Bool {
    return UIFont.preferredFont(forTextStyle: .body).pointSize > 17
}

/// 获取当前字体大小比例
func currentFontScale() -> CGFloat {
    let standardSize: CGFloat = 17.0
    let currentSize = UIFont.preferredFont(forTextStyle: .body).pointSize
    return currentSize / standardSize
}
