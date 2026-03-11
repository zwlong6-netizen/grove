import Foundation

/// 专注会话状态枚举
enum SessionStatus: String, Codable, CaseIterable {
    case active      // 进行中
    case completed   // 已完成
    case abandoned   // 已放弃

    /// 状态是否可变
    var isMutable: Bool {
        switch self {
        case .active:
            return true
        case .completed, .abandoned:
            return false
        }
    }

    /// 状态显示名称
    var displayName: String {
        switch self {
        case .active:
            return "进行中"
        case .completed:
            return "已完成"
        case .abandoned:
            return "已放弃"
        }
    }
}
