# 实施计划：Forest Focus Timer (iOS)

**分支**: `[001-ios]` | **日期**: 2026-03-10 | **规范**: [spec.md](spec.md)
**输入**: 来自 `/specs/001-ios/spec.md` 的功能规范

**注意**: 此模板由 `/speckit.plan` 命令填充。执行工作流程请参见 `.specify/templates/plan-template.md`.

## 摘要

开发一款 iOS 专注计时器应用，采用森林成长模式提供视觉激励。用户可设定专注时长（15/25/45/60 分钟），期间树木以 2D 矢量插画形式经历 5 个生长阶段。应用使用 CoreData 进行本地持久化，支持后台计时、本地通知、统计追踪和森林视图展示。技术栈为 iOS 15+、SwiftUI、CoreData、Combine 框架和 UNUserNotificationCenter。

## 技术背景

<!--
  需要操作：将此部分内容替换为项目的技术细节.
  此处的结构以咨询性质呈现，用于指导迭代过程.
-->

**语言/版本**: Swift 5.9+ (iOS 15+)
**主要依赖**: SwiftUI, CoreData, Combine, UNUserNotificationCenter
**存储**: CoreData (iOS 15+ 原生数据持久化框架) + CloudKit(可选同步)
**测试**: XCTest (单元测试) + XCUITest (UI 测试)
**目标平台**: iOS 15+ (iPhone)
**项目类型**: 移动应用 (iOS 原生)
**性能目标**: 60 FPS 动画，冷启动 < 2 秒，内存占用 < 150MB
**约束条件**: 无第三方依赖，离线优先，后台计时准确性
**规模/范围**: 5 个核心用户故事，约 10-15 个屏幕/状态

## 章程检查

*门控：必须在阶段 0 研究前通过。阶段 1 设计后重新检查。*

### Grove 项目合规性检查清单

#### 离线优先 ✅
- [x] 核心功能无网络请求即可使用
- [x] 本地数据存储方案已选择 (CoreData)
- [x] 云端同步为非阻塞/可选功能 (CloudKit 可选，不支持强制)

#### 测试先行开发 ✅
- [x] XCTest 测试框架已配置
- [x] 测试目录结构已规划 (unit/integration)
- [x] CI 流程包含测试运行步骤

#### 性能纪律 ✅
- [x] 冷启动性能基准测试已设置 (< 2 秒)
- [x] 60 FPS 动画目标已明确定义
- [x] 内存监控工具已配置 (< 50MB)

#### 无障碍访问 ✅
- [x] VoiceOver 测试设备已准备
- [x] 动态字体测试计划已制定
- [x] WCAG 2.1 AA 检查清单已创建

#### 极致简洁 ✅
- [x] 界面内容数量限制已设定 (<500 字/屏)
- [x] 3 次点击规则已应用

#### 森林美学 ✅
- [x] 自然色调色板已定义
- [x] 自定义缓动曲线参数已确定
- [x] 深色模式支持已规划

**检查结果**: 全部通过

## 项目结构

### 文档 (此功能)

```
specs/001-ios/
├── plan.md              # 此文件
├── research.md          # 阶段 0 输出
├── data-model.md        # 阶段 1 输出
├── quickstart.md        # 阶段 1 输出
├── contracts/           # 阶段 1 输出 (如有外部接口)
└── tasks.md             # 阶段 2 输出
```

### 源代码 (仓库根目录)

```
ForestFocusTimer/
├── ForestFocusTimerApp.swift    # 应用入口
├── Models/
│   ├── FocusSession.swift       # 专注会话数据模型
│   ├── Tree.swift               # 树木实体
│   └── Statistics.swift         # 统计数据模型
├── Views/
│   ├── Home/
│   │   ├── HomeView.swift       # 主界面
│   │   └── DurationPicker.swift # 时长选择器
│   ├── Focus/
│   │   ├── FocusView.swift      # 专注中界面
│   │   ├── TreeGrowthView.swift # 树木生长动画
│   │   └── PauseMenu.swift      # 暂停菜单
│   ├── Forest/
│   │   ├── ForestView.swift     # 森林视图
│   │   └── TreeGridView.swift   # 树木网格
│   ├── Statistics/
│   │   ├── StatisticsView.swift # 统计面板
│   │   └── StreakCard.swift     # 连胜卡片
│   └── Components/
│       ├── TreeStageView.swift  # 树木阶段组件
│       └── StatCard.swift       # 统计卡片组件
├── ViewModels/
│   ├── TimerViewModel.swift     # 计时器逻辑
│   ├── ForestViewModel.swift    # 森林数据管理
│   └── StatisticsViewModel.swift# 统计计算逻辑
├── Services/
│   ├── TimerService.swift       # 后台计时服务
│   ├── NotificationService.swift# 本地通知管理
│   └── HapticService.swift      # 触觉反馈
├── Utilities/
│   ├── TreeStages.swift         # 树木阶段定义
│   └── Constants.swift          # 应用常量
├── Resources/
│   ├── Assets.xcassets          # 资源文件
│   └── TreeImages/              # 2D 树木插画资源
└── Tests/
    ├── Unit/
    │   ├── TimerServiceTests.swift
    │   └── StatisticsTests.swift
    └── Integration/
        └── FocusSessionTests.swift
```

**结构决策**: 采用 MVVM-C 架构，按功能模块组织目录结构。Views 按用户流程分组 (Home, Focus, Forest, Statistics)，ViewModels 分离业务逻辑，Services 封装系统 API（计时、通知、触觉）。使用依赖注入实现服务层解耦。

## 复杂度跟踪

> **仅在章程检查有必须证明的违规时填写**

本章程检查全部通过，无需填写复杂度跟踪表。

## 阶段 0: 研究

### 研究主题

1. **CoreData 最佳实践**
   - Decision: 使用 CoreData 作为核心数据持久化方案
   - Rationale: iOS 15+ 原生支持，成熟稳定，支持 CloudKit 同步，与 SwiftUI 可通过 NSManagedObject 集成
   - Alternatives considered: SwiftData（更现代但需要 iOS 17+）、Realm（第三方依赖）

2. **Combine 定时器实现**
   - Decision: 使用 Combine 的 `Timer.publish` 实现专注计时器
   - Rationale: 声明式响应式编程，易于暂停/恢复，与 SwiftUI 状态管理无缝集成
   - Alternatives considered: Foundation.Timer（命令式，易出错）、DispatchQueue.asyncAfter（不适合重复计时）

3. **UNUserNotificationCenter 本地通知**
   - Decision: 使用 UNUserNotificationCenter 实现专注完成通知
   - Rationale: iOS 标准通知框架，支持定时通知、交互动作，后台可用
   - Alternatives considered: 应用内弹窗（仅前台有效）、推送通知（需要服务器）

4. **SwiftUI 60 FPS 动画技术**
   - Decision: 使用 `withAnimation(.easeOut)` 和 `TimelineView` 实现流畅动画
   - Rationale: SwiftUI 原生动画系统自动优化帧率，声明式语法简洁
   - Alternatives considered: UIKit 动画（更底层但复杂度更高）、Core Animation（性能最佳但学习曲线陡）

5. **2D 矢量插画资源管理**
   - Decision: 使用 SF Symbols 风格自定义 SVG 资源，按树木生长阶段命名
   - Rationale: SVG 矢量图清晰度高，文件体积小，易于深色模式适配
   - Alternatives considered: PNG 位图（放大失真）、程序化绘制（复杂度高）

---

## 阶段 1: 设计与合同

### 数据模型设计 (data-model.md)

#### 实体：FocusSession (专注会话)

```swift
class FocusSession: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var startTime: Date
    @NSManaged var plannedDuration: Int  // 分钟
    @NSManaged var actualElapsedTime: Int // 秒
    @NSManaged var status: String // "active", "completed", "abandoned"
    @NSManaged var treeStage: Int // 0-4
    @NSManaged var tree: Tree?    // 关联的树木 (完成后)
}
```

#### 实体：Tree (树木)

```swift
class Tree: NSManagedObject, Identifiable {
    @NSManaged var id: UUID
    @NSManaged var plantedDate: Date
    @NSManaged var session: FocusSession?  // 反向关联
    @NSManaged var isDeleted: Bool         // 软删除标记
}
```

#### 关系与约束

- FocusSession 1:0..1 Tree (一对一，可选)
- 删除 Session 级联删除关联的 Tree

### 接口合同 (contracts/)

#### UI 合同

- **HomeView**: 显示时长选择器和开始按钮，3 次点击内开始专注
- **FocusView**: 显示当前阶段树木、剩余时间、暂停/放弃按钮
- **ForestView**: 网格布局展示所有已完成的树木，支持点击查看详情
- **StatisticsView**: 显示总数、总时间、今日计数、连胜记录

#### 后台计时合同

- 应用进入后台后，使用 `Date` 时间差计算实际经过时间
- 返回前台时，UI 同步更新到正确状态

### 快速开始指南 (quickstart.md)

#### 前置条件

- Xcode 15+
- iOS 15.0+ 模拟器或真机
- Swift 5.9+

#### 构建设骤

1. 克隆仓库并打开 `ForestFocusTimer.xcodeproj`
2. 选择目标设备 (iPhone 15 Pro 或更新)
3. 运行 `Cmd+R` 构建并启动

#### 运行测试

```bash
xcodebuild test -scheme ForestFocusTimer -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 代理上下文更新

执行 `.specify/scripts/bash/update-agent-context.sh claude` 更新代理上下文文件。

---

## 阶段 2: 任务分解 (由 /speckit.tasks 生成)

**状态**: 待执行 `/speckit.tasks` 命令生成 tasks.md

**制品完成**:
- [x] research.md (研究文档，本章已包含)
- [x] data-model.md (独立文件，完整数据模型设计)
- [x] quickstart.md (独立文件，快速开始指南)
- [x] contracts/ui-contracts.md (接口合同目录)
- [ ] tasks.md (由 /speckit.tasks 生成)

**建议的下一个命令**: `/speckit.tasks`
