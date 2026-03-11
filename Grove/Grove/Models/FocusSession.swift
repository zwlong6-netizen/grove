import Foundation
import SwiftData

/// 专注会话 - 代表一次专注尝试
@Model
final class FocusSession {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID

    // MARK: - Temporal Properties
    var startTime: Date
    var endTime: Date?
    var plannedDurationMinutes: Int
    var actualElapsedTimeSeconds: Int

    // MARK: - State
    var status: SessionStatus
    var currentTreeStage: Int

    // MARK: - Relationships
    @Relationship var tree: Tree?

    // MARK: - Computed Properties
    var progress: Double {
        guard plannedDurationMinutes > 0 else { return 0 }
        return Double(actualElapsedTimeSeconds) / Double(plannedDurationMinutes * 60)
    }

    var isCompleted: Bool { status == .completed }
    var isAbandoned: Bool { status == .abandoned }
    var isActive: Bool { status == .active }

    // MARK: - Init
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        plannedDurationMinutes: Int = 25,
        actualElapsedTimeSeconds: Int = 0,
        status: SessionStatus = .active,
        currentTreeStage: Int = 0
    ) {
        self.id = id
        self.startTime = startTime
        self.plannedDurationMinutes = plannedDurationMinutes
        self.actualElapsedTimeSeconds = actualElapsedTimeSeconds
        self.status = status
        self.currentTreeStage = currentTreeStage
    }
}

// MARK: - Tree Stage Computation
extension FocusSession {
    /// 根据经过时间计算当前树木生长阶段 (0-4)
    func computeTreeStage() -> Int {
        let totalSeconds = plannedDurationMinutes * 60
        let progress = Double(actualElapsedTimeSeconds) / Double(totalSeconds)

        // 5 个生长阶段
        if progress < 0.2 { return 0 }
        if progress < 0.4 { return 1 }
        if progress < 0.6 { return 2 }
        if progress < 0.8 { return 3 }
        return 4
    }

    /// 更新经过时间并自动计算生长阶段
    func updateElapsedTime(_ seconds: Int) {
        actualElapsedTimeSeconds = seconds
        currentTreeStage = computeTreeStage()
    }
}

// MARK: - State Transitions
extension FocusSession {
    /// 完成会话
    func complete() {
        guard status == .active else { return }
        status = .completed
        endTime = Date()
        currentTreeStage = 4 // 最终阶段
    }

    /// 放弃会话
    func abandon() {
        guard status == .active else { return }
        status = .abandoned
        endTime = Date()
    }
}
