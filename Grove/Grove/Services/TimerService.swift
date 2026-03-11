import Foundation
import Combine
import SwiftUI

/// 计时器服务错误
enum TimerServiceError: LocalizedError {
    case noActiveSession
    case sessionAlreadyCompleted
    case invalidDuration

    var errorDescription: String? {
        switch self {
        case .noActiveSession:
            return "没有活跃的专注会话"
        case .sessionAlreadyCompleted:
            return "会话已完成"
        case .invalidDuration:
            return "无效的专注时长"
        }
    }
}

/// 计时器服务状态
enum TimerServiceState {
    case idle
    case running
    case paused
    case completed
}

/// 后台计时服务
///
/// 使用 Combine 的 Timer 实现专注计时
/// 支持后台计时，使用 Date 时间差计算确保准确性
@MainActor
class TimerService: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var state: TimerServiceState = .idle
    @Published private(set) var remainingTime: Int = 0
    @Published private(set) var elapsedSeconds: Int = 0
    @Published private(set) var currentStage: Int = 0
    @Published private(set) var error: TimerServiceError?

    // MARK: - Configuration
    private var plannedDurationMinutes: Int = 25
    private var totalSeconds: Int { plannedDurationMinutes * 60 }

    // MARK: - Timer
    private var timerCancellable: AnyCancellable?
    private var startDate: Date?
    private var backgroundStartDate: Date?

    // MARK: - Timer Publisher
    private lazy var timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common)

    // MARK: - Callbacks
    var onTick: ((Int, Int) -> Void)?      // (elapsedSeconds, stage)
    var onComplete: (() -> Void)?
    var onBackgroundTick: ((Int) -> Void)? // 后台时间更新回调

    // MARK: - Init
    init() {}

    // MARK: - Public Methods

    /// 启动专注计时器
    /// - Parameter durationMinutes: 专注时长（分钟）
    func start(durationMinutes: Int) {
        guard [15, 25, 45, 60].contains(durationMinutes) else {
            error = .invalidDuration
            return
        }

        plannedDurationMinutes = durationMinutes
        remainingTime = totalSeconds
        elapsedSeconds = 0
        currentStage = 0
        startDate = Date()
        backgroundStartDate = Date()
        state = .running

        // 启动计时器
        timerCancellable = timerPublisher
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    /// 暂停计时器
    func pause() {
        guard state == .running else { return }
        timerCancellable?.cancel()
        state = .paused
    }

    /// 恢复计时器
    func resume() {
        guard state == .paused else { return }
        state = .running
        backgroundStartDate = Date()

        timerCancellable = timerPublisher
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    /// 停止计时器（放弃）
    func stop() {
        timerCancellable?.cancel()
        state = .idle
        backgroundStartDate = nil
    }

    /// 计算后台经过的时间
    /// 当应用从后台返回时调用
    func computeBackgroundElapsedTime() -> Int {
        guard let backgroundStart = backgroundStartDate,
              state == .running else {
            return elapsedSeconds
        }

        let now = Date()
        let backgroundElapsed = Int(now.timeIntervalSince(backgroundStart))

        return min(elapsedSeconds + backgroundElapsed, totalSeconds)
    }

    /// 同步后台时间并更新状态
    func syncBackgroundTime() {
        let newElapsed = computeBackgroundElapsedTime()
        updateElapsedTime(newElapsed)
    }

    // MARK: - Private Methods

    /// 计时器滴答
    private func tick() {
        guard state == .running else { return }

        elapsedSeconds += 1

        if elapsedSeconds >= totalSeconds {
            // 完成
            elapsedSeconds = totalSeconds
            remainingTime = 0
            currentStage = 4
            state = .completed
            timerCancellable?.cancel()
            onComplete?()
        } else {
            // 更新
            remainingTime = totalSeconds - elapsedSeconds
            currentStage = TreeStageConfig.stage(elapsedSeconds: elapsedSeconds, totalSeconds: totalSeconds)
        }

        onTick?(elapsedSeconds, currentStage)
    }

    /// 更新经过时间（用于后台同步）
    private func updateElapsedTime(_ seconds: Int) {
        elapsedSeconds = min(seconds, totalSeconds)
        remainingTime = max(0, totalSeconds - elapsedSeconds)
        currentStage = TreeStageConfig.stage(elapsedSeconds: elapsedSeconds, totalSeconds: totalSeconds)

        if elapsedSeconds >= totalSeconds {
            state = .completed
            onComplete?()
        }

        onTick?(elapsedSeconds, currentStage)
        onBackgroundTick?(elapsedSeconds)
    }

    // MARK: - Format Helpers

    /// 格式化剩余时间
    var formattedRemainingTime: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// 格式化经过时间
    var formattedElapsedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// 进度百分比
    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(elapsedSeconds) / Double(totalSeconds)
    }
}
