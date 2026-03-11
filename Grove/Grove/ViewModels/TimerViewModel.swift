import Foundation
import Combine
import SwiftUI
import SwiftData

/// 计时器视图模型
///
/// 负责管理专注计时的业务逻辑和状态
@MainActor
class TimerViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var state: TimerServiceState = .idle
    @Published var remainingTime: Int = 0
    @Published var elapsedSeconds: Int = 0
    @Published var currentStage: Int = 0
    @Published var selectedDuration: Int = 25
    @Published var isPaused: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    // MARK: - Services

    private let timerService: TimerService
    private let notificationService: NotificationService
    private let modelContext: ModelContext

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()
    private var activeSession: FocusSession?

    // MARK: - Computed Properties

    var formattedRemainingTime: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var formattedElapsedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: Double {
        let totalSeconds = selectedDuration * 60
        guard totalSeconds > 0 else { return 0 }
        return Double(elapsedSeconds) / Double(totalSeconds)
    }

    var currentTreeStage: TreeStage {
        TreeStage.allCases[safe: currentStage] ?? .seed
    }

    // MARK: - Init

    init(
        timerService: TimerService = TimerService(),
        notificationService: NotificationService = NotificationService(),
        modelContext: ModelContext
    ) {
        self.timerService = timerService
        self.notificationService = notificationService
        self.modelContext = modelContext
        setupBindings()
    }

    // MARK: - Setup

    private func setupBindings() {
        // 绑定计时器服务状态
        timerService.$state
            .sink { [weak self] newState in
                self?.state = newState
                self?.isPaused = (newState == .paused)
            }
            .store(in: &cancellables)

        // 绑定剩余时间
        timerService.$remainingTime
            .sink { [weak self] time in
                self?.remainingTime = time
            }
            .store(in: &cancellables)

        // 绑定经过时间
        timerService.$elapsedSeconds
            .sink { [weak self] time in
                self?.elapsedSeconds = time
            }
            .store(in: &cancellables)

        // 绑定当前阶段
        timerService.$currentStage
            .sink { [weak self] stage in
                self?.currentStage = stage
            }
            .store(in: &cancellables)

        // 绑定完成回调
        timerService.onComplete = { [weak self] in
            Task { @MainActor in
                await self?.handleFocusComplete()
            }
        }

        // 绑定滴答回调
        timerService.onTick = { [weak self] elapsed, stage in
            self?.activeSession?.updateElapsedTime(elapsed)
        }
    }

    // MARK: - Public Methods

    /// 开始专注
    func startFocus() {
        guard state == .idle else { return }

        // 创建新的专注会话
        let session = FocusSession(
            plannedDurationMinutes: selectedDuration,
            status: .active
        )
        activeSession = session
        modelContext.insert(session)

        // 启动计时器
        timerService.start(durationMinutes: selectedDuration)

        // 调度通知
        Task {
            try? await notificationService.scheduleFocusComplete(delay: selectedDuration * 60)
        }

        // 通知 VoiceOver
        AccessibilityNotification.announce("开始专注，时长\(selectedDuration)分钟")
    }

    /// 暂停专注
    func pauseFocus() {
        guard state == .running else { return }
        timerService.pause()
        AccessibilityNotification.announce("专注已暂停")
    }

    /// 恢复专注
    func resumeFocus() {
        guard state == .paused else { return }
        timerService.resume()
        AccessibilityNotification.announce("专注已恢复")
    }

    /// 放弃专注
    func abandonFocus() {
        guard state == .running || state == .paused else { return }

        // 更新会话状态
        activeSession?.abandon()

        // 停止计时器
        timerService.stop()

        // 取消通知
        Task {
            await notificationService.cancelAllNotifications()
        }

        // 保存上下文
        try? modelContext.save()

        // 重置状态
        resetState()

        AccessibilityNotification.announce("专注已放弃")
    }

    /// 完成专注
    func completeFocus() {
        guard state == .completed else { return }

        // 更新会话状态
        activeSession?.complete()

        // 创建树木
        if let session = activeSession {
            let tree = Tree(
                plantedDate: session.startTime,
                durationSeconds: session.actualElapsedTimeSeconds,
                treeStage: 4,
                session: session
            )
            session.tree = tree
            modelContext.insert(tree)
        }

        // 保存上下文
        try? modelContext.save()

        // 重置状态
        resetState()

        AccessibilityNotification.announce("专注完成！树木已种下")
    }

    /// 同步后台时间
    func syncBackgroundTime() {
        timerService.syncBackgroundTime()
    }

    // MARK: - Private Methods

    private func handleFocusComplete() async {
        completeFocus()
    }

    private func resetState() {
        activeSession = nil
        remainingTime = 0
        elapsedSeconds = 0
        currentStage = 0
        state = .idle
        isPaused = false
    }

    // MARK: - Duration Selection

    func selectDuration(_ minutes: Int) {
        guard [15, 25, 45, 60].contains(minutes) else { return }
        selectedDuration = minutes
    }
}

// MARK: - Array Extension

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
