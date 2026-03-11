import Foundation
import SwiftUI

/// 树木生长阶段定义
///
/// 5 个清晰的生长阶段，使用 2D 矢量插画风格
/// 每个阶段有明显的视觉差异（颜色/尺寸变化>=30%）
enum TreeStage: Int, CaseIterable {
    case seed = 0      // 种子
    case sprout = 1    // 嫩芽
    case sapling = 2   // 幼苗
    case young = 3     // 青年树
    case mature = 4    // 成熟树

    /// 阶段显示名称
    var displayName: String {
        switch self {
        case .seed: return "种子"
        case .sprout: return "嫩芽"
        case .sapling: return "幼苗"
        case .young: return "青年树"
        case .mature: return "成熟树"
        }
    }

    /// 阶段描述
    var description: String {
        switch self {
        case .seed: return "专注开始，种子正在萌芽"
        case .sprout: return "专注进行中，嫩芽破土而出"
        case .sapling: return "专注持续，幼苗茁壮成长"
        case .young: return "专注接近完成，树木逐渐成型"
        case .mature: return "专注完成，大树茁壮成长"
        }
    }

    /// 相对尺寸比例 (相对于成熟树)
    var sizeRatio: CGFloat {
        switch self {
        case .seed: return 0.2
        case .sprout: return 0.4
        case .sapling: return 0.6
        case .young: return 0.8
        case .mature: return 1.0
        }
    }

    /// 主色调 (浅色模式)
    var primaryColor: Color {
        switch self {
        case .seed: return Color.brown.opacity(0.7)
        case .sprout: return Color.green.opacity(0.6)
        case .sapling: return Color.green.opacity(0.8)
        case .young: return Color.green.opacity(0.9)
        case .mature: return Color(red: 0.2, green: 0.6, blue: 0.2)
        }
    }

    /// 辅助色调
    var accentColor: Color {
        switch self {
        case .seed: return Color.orange.opacity(0.5)
        case .sprout: return Color.yellow.opacity(0.4)
        case .sapling: return Color.yellowGreen.opacity(0.5)
        case .young: return Color.green.opacity(0.6)
        case .mature: return Color(red: 0.1, green: 0.5, blue: 0.1)
        }
    }

    /// 深色模式主色调
    var primaryColorDark: Color {
        switch self {
        case .seed: return Color.brown.opacity(0.8)
        case .sprout: return Color.green.opacity(0.7)
        case .sapling: return Color.green.opacity(0.85)
        case .young: return Color.green.opacity(0.95)
        case .mature: return Color(red: 0.4, green: 0.7, blue: 0.4)
        }
    }
}

/// 树木生长阶段配置
struct TreeStageConfig {
    /// 所有阶段
    static let allStages = TreeStage.allCases

    /// 阶段总数
    static let count = TreeStage.allCases.count

    /// 根据进度获取阶段
    static func stage(for progress: Double) -> TreeStage {
        guard progress >= 0 else { return .seed }
        guard progress < 1.0 else { return .mature }

        let stageIndex = Int(progress * Double(count))
        return TreeStage.allCases[min(stageIndex, count - 1)]
    }

    /// 根据已用时间和总时长获取阶段
    static func stage(elapsedSeconds: Int, totalSeconds: Int) -> TreeStage {
        guard totalSeconds > 0 else { return .seed }
        let progress = Double(elapsedSeconds) / Double(totalSeconds)
        return stage(for: progress)
    }
}
