# 数据模型设计

本文档定义 Forest Focus Timer 应用的核心数据模型、关系和验证规则。

## 技术栈

- **持久化框架**: SwiftData (iOS 17+)
- **数据绑定**: Combine + SwiftUI @Observable
- **迁移策略**: 轻量级迁移 (自动)

---

## 核心实体

### FocusSession (专注会话)

代表一次专注尝试，无论成功或失败。

```swift
import SwiftData

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
```

#### 字段说明

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | unique, not null | 唯一标识符 |
| startTime | Date | not null | 会话开始时间 |
| endTime | Date? | nullable | 会话结束时间 (可选) |
| plannedDurationMinutes | Int | 15/25/45/60 | 预设时长 |
| actualElapsedTimeSeconds | Int | >= 0 | 实际经过时间 (秒) |
| status | SessionStatus | enum | 当前状态 |
| currentTreeStage | Int | 0-4 | 树木生长阶段 |

#### 状态转换

```
.active --(完成)--> .completed
.active --(放弃)--> .abandoned
.completed --(不可变)
.abandoned --(不可变)
```

#### 验证规则

- `plannedDurationMinutes` 必须是 [15, 25, 45, 60] 之一
- `actualElapsedTimeSeconds` 必须 >= 0
- `currentTreeStage` 必须在 0-4 范围内
- `.completed` 和 `.abandoned` 状态不可变更

---

### Tree (树木)

代表一次成功专注的结果，用于森林展示。

```swift
import SwiftData

@Model
final class Tree {
    // MARK: - Identity
    @Attribute(.unique) var id: UUID

    // MARK: - Properties
    var plantedDate: Date
    var durationSeconds: Int
    var treeStage: Int  // 完成时的阶段 (总是 4)
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
```

#### 字段说明

| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | UUID | unique, not null | 唯一标识符 |
| plantedDate | Date | not null | 种植日期 |
| durationSeconds | Int | >= 0 | 专注时长 (秒) |
| treeStage | Int | = 4 | 完成时总是阶段 4 |
| isDeleted | Bool | default false | 软删除标记 |

#### 业务规则

- Tree 仅在 FocusSession 状态变为 `.completed` 时创建
- 删除 Session 时，关联的 Tree 软删除 (`isDeleted = true`)
- 森林视图仅展示 `isDeleted == false` 的树木

---

### SessionStatus (枚举)

```swift
enum SessionStatus: String, Codable, CaseIterable {
    case active      // 进行中
    case completed   // 已完成
    case abandoned   // 已放弃
}
```

---

## 关系统

```
FocusSession (1) ---- (0..1) Tree
    ↑
    └── 一对一，可选
        - Tree 仅在 Session 完成后存在
        - 删除 Session 级联软删除 Tree
```

### 关系配置

```swift
// FocusSession 中:
@Relationship(deleteRule: .nullify) var tree: Tree?

// Tree 中:
@Relationship(deleteRule: .cascade) var session: FocusSession?
```

---

## 查询示例

### 获取所有活跃会话
```swift
@Query(filter: #Predicate<FocusSession> { $0.status == .active })
var activeSessions: [FocusSession]
```

### 获取所有可展示的树木
```swift
@Query(
    filter: #Predicate<Tree> { $0.isDeleted == false },
    sort: \.plantedDate,
    order: .reverse
)
var forestTrees: [Tree]
```

### 获取今日完成的会话
```swift
@Query(
    filter: #Predicate<FocusSession> {
        $0.status == .completed &&
        Calendar.current.isDateInToday($0.startTime)
    }
)
var todaySessions: [FocusSession]
```

---

## 数据迁移策略

### Schema Versioning

```swift
let container = try ModelContainer(
    for: FocusSession.self, Tree.self,
    migrations: [
        .named("InitialSchema", version: 1)
    ]
)
```

### 迁移规则

- 新增可选字段：默认值 + 轻量级迁移
- 新增非可选字段：需要手动迁移代码
- 删除字段：保留一个版本用于回滚

---

## 测试数据工厂

```swift
struct TestFactory {
    static func makeSession(
        status: SessionStatus = .active,
        elapsedSeconds: Int = 0
    ) -> FocusSession {
        FocusSession(
            plannedDurationMinutes: 25,
            actualElapsedTimeSeconds: elapsedSeconds,
            status: status,
            currentTreeStage: min(elapsedSeconds / 300, 4)
        )
    }

    static func makeTree(session: FocusSession) -> Tree {
        Tree(
            plantedDate: session.startTime,
            durationSeconds: session.actualElapsedTimeSeconds,
            session: session
        )
    }
}
```

---

## 性能考虑

### 索引策略

- `FocusSession.startTime`: 用于时间范围查询
- `Tree.plantedDate`: 用于森林排序
- `FocusSession.status`: 用于状态过滤

### 批量操作

```swift
// 批量删除已软标记的树木
func cleanupDeletedTrees(context: ModelContext) {
    do {
        try context.delete(
            model: Tree.self,
            where: #Predicate<Tree> { $0.isDeleted == true }
        )
        try context.save()
    } catch {
        print("Cleanup failed: \(error)")
    }
}
```
