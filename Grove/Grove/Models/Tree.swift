import Foundation
import SwiftData

/// 树木实体 - 代表一次成功专注的结果
@Model
final class Tree {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID

    // MARK: - Properties
    var plantedDate: Date
    var durationSeconds: Int
    var treeStage: Int  // 完成时总是阶段 4
    var isDeleted: Bool // 软删除标记

    // MARK: - Relationships
    @Relationship var session: FocusSession?

    // MARK: - Metadata
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Init
    init(
        id: UUID = UUID(),
        plantedDate: Date = Date(),
        durationSeconds: Int = 0,
        treeStage: Int = 4,
        isDeleted: Bool = false,
        session: FocusSession? = nil
    ) {
        self.id = id
        self.plantedDate = plantedDate
        self.durationSeconds = durationSeconds
        self.treeStage = treeStage
        self.isDeleted = isDeleted
        self.session = session
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
