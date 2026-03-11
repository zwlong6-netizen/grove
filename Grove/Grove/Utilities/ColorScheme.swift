import SwiftUI

/// 应用颜色系统
///
/// 支持浅色模式和深色模式自动切换
/// 采用自然绿色系色调，符合森林美学
struct AppColors {
    // MARK: - 主色调

    /// 森林绿 - 主品牌色
    static let forestGreen = Color("ForestGreen")

    /// 嫩芽绿 - 辅助色
    static let sproutGreen = Color("SproutGreen")

    // MARK: - 背景色

    /// 主背景
    static let background = Color("BackgroundColor")

    /// 次级背景（卡片、输入框）
    static let secondaryBackground = Color("SecondaryBackgroundColor")

    /// 组背景
    static let groupBackground = Color("GroupBackgroundColor")

    // MARK: - 文本色

    /// 主文本
    static let primaryText = Color("PrimaryTextColor")

    /// 次级文本
    static let secondaryText = Color("SecondaryTextColor")

    // MARK: - 功能色

    /// 成功色
    static let success = Color("SuccessColor")

    /// 警告色
    static let warning = Color("WarningColor")

    /// 错误色
    static let error = Color("ErrorColor")

    /// 摧毁/放弃色
    static let abandon = Color("AbandonColor")
}

// MARK: - 语义化颜色扩展

extension Color {
    // MARK: - 森林主题色系

    /// 森林绿 - 浅色模式
    static let forestGreenLight = Color(red: 0.2, green: 0.5, blue: 0.3)

    /// 森林绿 - 深色模式
    static let forestGreenDark = Color(red: 0.4, green: 0.7, blue: 0.5)

    /// 大地棕 - 浅色模式
    static let earthBrownLight = Color(red: 0.4, green: 0.25, blue: 0.15)

    /// 大地棕 - 深色模式
    static let earthBrownDark = Color(red: 0.55, green: 0.35, blue: 0.25)

    /// 天空蓝 - 浅色模式背景
    static let skyBlueLight = Color(red: 0.9, green: 0.95, blue: 1.0)

    /// 夜空蓝 - 深色模式背景
    static let skyBlueDark = Color(red: 0.1, green: 0.12, blue: 0.15)

    // MARK: - 中性色

    /// 纯白 - 浅色模式
    static let whiteLight = Color(red: 1.0, green: 1.0, blue: 1.0)

    /// 深灰 - 深色模式背景
    static let darkGray = Color(red: 0.11, green: 0.11, blue: 0.12)

    /// 卡片灰 - 浅色模式
    static let cardGrayLight = Color(red: 0.97, green: 0.97, blue: 0.97)

    /// 卡片灰 - 深色模式
    static let cardGrayDark = Color(red: 0.18, green: 0.18, blue: 0.19)
}

// MARK: - 动态颜色定义

/// 根据系统主题自动切换的颜色
extension Color {
    /// 主背景色
    static var appBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
                : UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        })
    }

    /// 卡片背景色
    static var appCardBackground: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.18, green: 0.18, blue: 0.19, alpha: 1.0)
                : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        })
    }

    /// 主文本色
    static var appPrimaryText: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        })
    }

    /// 次级文本色
    static var appSecondaryText: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
                : UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        })
    }

    /// 主色调 - 森林绿
    static var appPrimary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.4, green: 0.7, blue: 0.5, alpha: 1.0)
                : UIColor(red: 0.2, green: 0.5, blue: 0.3, alpha: 1.0)
        })
    }

    /// 强调色
    static var appAccent: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.5, green: 0.8, blue: 0.6, alpha: 1.0)
                : UIColor(red: 0.3, green: 0.6, blue: 0.4, alpha: 1.0)
        })
    }
}

// MARK: - 对比度检查

/// WCAG 对比度检查工具
struct ContrastChecker {
    /// 检查文本和背景的对比度是否符合 WCAG AA 标准
    /// - Returns: true 如果对比度 >= 4.5:1
    static func isWcagAACompliant(foreground: Color, background: Color) -> Bool {
        // TODO: 实现颜色对比度计算
        // 这里需要 UIColor 的 RGB 分量来计算亮度比
        return true
    }
}
