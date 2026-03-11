import Foundation
import UserNotifications

/// 通知服务错误
enum NotificationServiceError: LocalizedError {
    case authorizationDenied
    case notificationNotAllowed
    case failedToSchedule

    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "通知权限被拒绝"
        case .notificationNotAllowed:
            return "通知不被允许"
        case .failedToSchedule:
            return "无法调度通知"
        }
    }
}

/// 通知服务
///
/// 使用 UNUserNotificationCenter 实现本地通知
@MainActor
class NotificationService: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isAuthorized: Bool = false
    @Published private(set) var error: NotificationServiceError?

    // MARK: - Properties
    private let center: UNUserNotificationCenter
    private let notificationIdentifier = "forest.focus.complete"

    // MARK: - Init
    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    // MARK: - Public Methods

    /// 请求通知授权
    func requestAuthorization() async throws -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            if !granted {
                error = .authorizationDenied
            }
            return granted
        } catch {
            error = .authorizationDenied
            throw error
        }
    }

    /// 检查通知权限
    func checkAuthorization() async {
        let settings = await center.notificationSettings()
        isAuthorized = (settings.authorizationStatus == .authorized)
    }

    /// 调度专注完成通知
    /// - Parameter delay: 延迟秒数
    func scheduleFocusComplete(delay: Int) async throws {
        guard isAuthorized else {
            error = .notificationNotAllowed
            throw NotificationServiceError.notificationNotAllowed
        }

        // 移除旧的通知
        await center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])

        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "专注完成！"
        content.body = "恭喜，你已经成功完成了一次专注。树木已经种下！"
        content.sound = .default
        content.categoryIdentifier = "FOCUS_COMPLETE"

        // 创建触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)

        // 创建请求
        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )

        // 添加通知
        do {
            try await center.add(request)
        } catch {
            error = .failedToSchedule
            throw error
        }
    }

    /// 取消所有待处理的通知
    func cancelAllNotifications() async {
        await center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }

    /// 取消指定通知
    func cancelNotification(identifier: String) async {
        await center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - Notification Categories

    /// 注册通知类别和动作
    func registerCategories() {
        // 完成动作
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_ACTION",
            title: "查看成果",
            options: .foreground
        )

        // 稍后动作
        let laterAction = UNNotificationAction(
            identifier: "LATER_ACTION",
            title: "稍后",
            options: .destructive
        )

        // 类别
        let category = UNNotificationCategory(
            identifier: "FOCUS_COMPLETE",
            actions: [completeAction, laterAction],
            intentIdentifiers: [],
            options: []
        )

        center.setNotificationCategories([category])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    /// 处理通知点击
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // 处理通知点击逻辑
        switch response.actionIdentifier {
        case "COMPLETE_ACTION":
            // 用户点击查看成果
            break
        case "LATER_ACTION":
            // 用户选择稍后
            break
        default:
            break
        }

        completionHandler()
    }

    /// 处理前台通知
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 前台也显示通知
        completionHandler([.banner, .sound])
    }
}
