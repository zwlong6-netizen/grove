# 任务：Forest Focus Timer (iOS)

**输入**: 来自 `/specs/001-ios/` 的设计文档
**前置条件**: plan.md(✓), spec.md(✓), data-model.md(✓), contracts/ui-contracts.md(✓)

**测试**: 功能规范明确要求 XCTest 单元测试和 XCUITest UI 测试

**组织结构**: 任务按用户故事分组，以便每个故事能够独立实施和测试

## 格式：`[ID] [P?] [Story] 描述`
- **[P]**: 可以并行运行 (不同文件，无依赖关系)
- **[Story]**: 此任务属于哪个用户故事 (例如：US1, US2, US3)
- 在描述中包含确切的文件路径

---

## 阶段 1: 设置 (共享基础设施)

**目的**: 项目初始化和基本结构

- [ ] T001 根据实施计划创建 ForestFocusTimer Xcode 项目
- [ ] T002 [P] 在 ForestFocusTimerApp.swift 中创建应用入口和 CoreData 容器
- [ ] T003 [P] 配置 Git 忽略列表 (.gitignore 包含 DerivedData, xcuserdata)

---

## 阶段 2: 基础 (阻塞前置条件)

**目的**: 在任何用户故事可以实施之前必须完成的核心基础设施

**⚠️ 关键**: 在此阶段完成之前，无法开始任何用户故事工作

- [ ] T004 [P] 在 Models/FocusSession.swift 中创建 FocusSession 数据模型
- [ ] T005 [P] 在 Models/Tree.swift 中创建 Tree 数据模型
- [ ] T006 [P] 在 Models/SessionStatus.swift 中创建 SessionStatus 枚举 (String 类型："active", "completed", "abandoned")
- [ ] T007 在 Utilities/TreeStages.swift 中定义 5 个树木生长阶段常量
- [ ] T008 [P] 在 Services/TimerService.swift 中实现后台计时服务框架
- [ ] T009 [P] 在 Services/NotificationService.swift 中实现通知服务框架
- [ ] T010 [P] 实现深色模式颜色系统 (章程强制要求)
- [ ] T011 [P] 添加 VoiceOver 无障碍访问标签基础框架 (章程强制要求)
- [ ] T012 实现动态字体支持基础框架 (最大 200%, 章程强制要求)

**检查点**: 基础就绪 - 现在可以开始并行实施用户故事 (包含无障碍访问，深色模式，动态字体支持)

---

## 阶段 3: 用户故事 1 - 开始专注植树 (优先级：P1)🎯 MVP

**目标**: 用户可以启动 25 分钟专注时段，树木随时间生长

**独立测试**: 从主界面开始专注，验证倒计时和树木生长阶段切换

### 用户故事 1 的测试⚠️

> **注意：先编写这些测试，确保在实施前它们失败**

- [ ] T013 [P] [US1] 在 Tests/Unit/TimerServiceTests.swift 中编写计时器启动/暂停测试
- [ ] T014 [P] [US1] 在 Tests/Integration/FocusSessionTests.swift 中编写专注会话生命周期测试

### 用户故事 1 的实施

- [ ] T015 [P] [US1] 在 ViewModels/TimerViewModel.swift 中实现 TimerViewModel
- [ ] T016 [P] [US1] 在 Views/Home/HomeView.swift 中创建主界面视图
- [ ] T017 [P] [US1] 在 Views/Home/DurationPicker.swift 中实现时长选择器组件
- [ ] T018 [US1] 在 Views/Focus/FocusView.swift 中创建专注中界面视图
- [ ] T019 [P] [US1] 在 Views/Focus/TreeGrowthView.swift 中实现树木生长视图 (5 阶段静态切换)
- [ ] T020 [US1] 在 Views/Focus/PauseMenu.swift 中实现暂停菜单
- [ ] T021 [US1] 在 Services/TimerService.swift 中实现 Combine Timer 计时逻辑
- [ ] T022 [US1] 实现后台时间差计算逻辑 (使用 Date 时间戳)
- [ ] T023 [US1] 在 FocusSession 中实现状态转换逻辑 (active→completed)

**检查点**: 此时，用户故事 1 应该完全功能化且可独立测试

---

## 阶段 4: 用户故事 2 - 中途放弃植树 (优先级：P2)

**目标**: 用户可以随时放弃专注，树木显示摧毁动画

**独立测试**: 在专注中点击放弃按钮，验证摧毁动画和未完成记录

### 用户故事 2 的测试⚠️

- [ ] T024 [P] [US2] 在 Tests/Unit/TimerServiceTests.swift 中编写放弃会话测试
- [ ] T025 [P] [US2] 在 Tests/Integration/FocusSessionTests.swift 中编写未完成会话持久化测试

### 用户故事 2 的实施

- [ ] T026 [P] [US2] 在 Views/Focus/AbandonConfirmationView.swift 中创建放弃确认弹窗
- [ ] T027 [US2] 在 Views/Focus/TreeDestructionAnimation.swift 中实现树木摧毁动画
- [ ] T028 [US2] 在 FocusSession 中实现状态转换逻辑 (active→abandoned)
- [ ] T029 [US2] 在 Services/TimerService.swift 中实现取消计时器逻辑
- [ ] T030 [US2] 在 ViewModels/TimerViewModel.swift 中添加放弃处理方法

**检查点**: 此时，用户故事 1 和 2 应该独立可运行

---

## 阶段 5: 用户故事 3 - 查看个人森林 (优先级：P1)🎯 MVP

**目标**: 用户查看已完成的专注会话历史，以树木网格形式展示

**独立测试**: 导航到森林视图，验证树木网格显示和点击详情

### 用户故事 3 的测试⚠️

- [ ] T031 [P] [US3] 在 Tests/Unit/ForestViewModelTests.swift 中编写森林数据加载测试
- [ ] T032 [P] [US3] 在 Tests/Integration/ForestViewTests.swift 中编写森林 UI 测试

### 用户故事 3 的实施

- [ ] T033 [P] [US3] 在 ViewModels/ForestViewModel.swift 中实现森林数据管理
- [ ] T034 [P] [US3] 在 Views/Forest/ForestView.swift 中创建森林视图
- [ ] T035 [P] [US3] 在 Views/Forest/TreeGridView.swift 中实现树木网格布局
- [ ] T036 [US3] 在 Views/Forest/TreeDetailView.swift 中创建树木详情弹窗
- [ ] T037 [US3] 在 ViewModels/ForestViewModel.swift 中实现删除树木功能
- [ ] T038 [US3] 使用 CoreData NSManagedObjectContext 实现数据持久化层

**检查点**: 此时，用户故事 1、2 和 3 应该独立可运行

---

## 阶段 6: 用户故事 4 - 查看统计数据 (优先级：P2)

**目标**: 用户查看专注统计数据 (总数、总时间、今日计数、连胜记录)

**独立测试**: 访问统计面板，验证所有指标正确计算和显示

### 用户故事 4 的测试⚠️

- [ ] T039 [P] [US4] 在 Tests/Unit/StatisticsViewModelTests.swift 中编写统计数据计算测试
- [ ] T040 [P] [US4] 在 Tests/Unit/StatisticsViewModelTests.swift 中编写连胜逻辑测试

### 用户故事 4 的实施

- [ ] T041 [P] [US4] 在 ViewModels/StatisticsViewModel.swift 中实现统计数据计算逻辑
- [ ] T042 [P] [US4] 在 Views/Statistics/StatisticsView.swift 中创建统计面板视图
- [ ] T043 [P] [US4] 在 Views/Statistics/StatCard.swift 中实现统计卡片组件
- [ ] T044 [US4] 在 Views/Statistics/StreakCard.swift 中实现连胜记录卡片
- [ ] T045 [US4] 实现今日计数日历日重置逻辑
- [ ] T046 [US4] 实现连续天数 (Streak) 计算逻辑

**检查点**: 所有核心用户故事现在应该独立功能化

---

## 阶段 7: 用户故事 5 - 接收专注提醒 (优先级：P2)

**目标**: 专注结束时发送本地通知，提供庆祝反馈

**独立测试**: 后台测试通知功能，验证专注结束时收到提示

### 用户故事 5 的测试⚠️

- [ ] T047 [P] [US5] 在 Tests/Unit/NotificationServiceTests.swift 中编写通知调度测试
- [ ] T048 [P] [US5] 在 Tests/Integration/NotificationTests.swift 中编写 UI 通知测试

### 用户故事 5 的实施

- [ ] T049 [P] [US5] 在 Services/NotificationService.swift 中实现 UNUserNotificationCenter 集成
- [ ] T050 [US5] 在 Services/NotificationService.swift 中实现通知调度方法
- [ ] T051 [US5] 在 Views/Focus/CompletionCelebrationView.swift 中实现完成庆祝界面
- [ ] T052 [US5] 在 Info.plist 中添加通知权限配置
- [ ] T053 [US5] 实现通知授权请求逻辑

**检查点**: 所有 5 个用户故事现在应该独立功能化

---

## 阶段 8: 完善与横切关注点

**目的**: 影响多个用户故事的改进

- [ ] T057 [P] 在 Resources/Assets.xcassets 中添加 2D 树木插画资源 (5 阶段×2 主题)
- [ ] T058 [P] 在 Tests/Unit 中添加额外的单元测试覆盖
- [ ] T059 [P] 在 Tests/Integration 中添加 UI 测试覆盖
- [ ] T060 代码清理和重构
- [ ] T061 性能优化 (冷启动<2 秒，内存占用<150MB)
- [ ] T062 运行 quickstart.md 验证
- [ ] T063 更新 README.md 项目文档

---

## 依赖关系与执行顺序

### 阶段依赖关系

- **设置 (阶段 1)**: 无依赖关系 - 可立即开始
- **基础 (阶段 2)**: 依赖于设置完成 - 阻塞所有用户故事
- **用户故事 (阶段 3-7)**: 都依赖于基础阶段完成
  - 用户故事可以按优先级顺序进行 (P1→P2→P3→P4→P5)
  - 每个故事完成后独立可测试
- **完善 (阶段 8)**: 依赖于所有用户故事完成

### 用户故事依赖关系

- **US1 (P1)**: 可在基础 (阶段 2) 后开始 - 无其他故事依赖
- **US2 (P2)**: 可在基础 (阶段 2) 后开始 - 依赖 US1 的计时器框架
- **US3 (P1)**: 可在基础 (阶段 2) 后开始 - 依赖数据模型
- **US4 (P2)**: 可在阶段 3 完成后开始 - 依赖森林数据
- **US5 (P2)**: 可在阶段 3 完成后开始 - 依赖完成状态

### 并行机会

- 所有标记为 [P] 的设置任务可以并行运行 (T002, T003)
- 所有标记为 [P] 的基础任务可以并行运行 (T004-T009)
- 用户故事中所有标记为 [P] 的任务可以并行运行
- 不同用户故事可以由不同开发人员并行处理

---

## 并行示例：用户故事 1

```bash
# 一起启动用户故事 1 的所有测试:
任务："在 Tests/Unit/TimerServiceTests.swift 中编写计时器启动/暂停测试"
任务："在 Tests/Integration/FocusSessionTests.swift 中编写专注会话生命周期测试"

# 一起启动用户故事 1 的所有模型/视图模型:
任务："在 ViewModels/TimerViewModel.swift 中实现 TimerViewModel"
任务："在 Views/Home/HomeView.swift 中创建主界面视图"
任务："在 Views/Home/DurationPicker.swift 中实现时长选择器组件"
```

---

## 实施策略

### 仅 MVP (用户故事 1 + 3)

1. 完成阶段 1: 设置
2. 完成阶段 2: 基础 (关键 - 阻塞所有故事)
3. 完成阶段 3: 用户故事 1 (核心专注功能)
4. 完成阶段 5: 用户故事 3 (森林展示)
5. **停止并验证**: 独立测试 MVP 功能
6. 如准备好则部署/TestFlight

### 增量交付

1. 完成设置 + 基础 → 基础就绪
2. 添加用户故事 1 → 独立测试 → TestFlight(MVP!)
3. 添加用户故事 3 → 独立测试 → TestFlight
4. 添加用户故事 2 → 独立测试 → TestFlight
5. 添加用户故事 4 → 独立测试 → TestFlight
6. 添加用户故事 5 → 独立测试 → 发布

### 并行团队策略

有多个开发人员时:

1. 团队一起完成设置 + 基础
2. 基础完成后:
   - 开发人员 A: 用户故事 1 (专注计时)
   - 开发人员 B: 用户故事 3 (森林视图)
3. 完成后:
   - 开发人员 A: 用户故事 2 (放弃功能)
   - 开发人员 B: 用户故事 4 (统计数据)
4. 最后:
   - 开发人员 A+B: 用户故事 5 (通知) + 完善

---

## 注意事项

- [P] 任务 = 不同文件，无依赖关系
- [Story] 标签将任务映射到特定用户故事以实现可追溯性
- 每个用户故事应该独立可完成和可测试
- 在实施前验证测试失败
- 在每个任务或逻辑组后提交
- 在任何检查点停止以独立验证故事
- 避免：模糊任务，相同文件冲突，破坏独立性的跨故事依赖

## 任务摘要

| 阶段 | 任务数 | 描述 |
|------|--------|------|
| 阶段 1: 设置 | 3 | 项目初始化 |
| 阶段 2: 基础 | 9 | 数据模型和服务框架 + 无障碍访问/深色模式/动态字体 (章程强制) |
| 阶段 3: US1 | 11 | 开始专注植树 (MVP) |
| 阶段 4: US2 | 7 | 中途放弃植树 |
| 阶段 5: US3 | 8 | 查看个人森林 (MVP) |
| 阶段 6: US4 | 8 | 查看统计数据 |
| 阶段 7: US5 | 7 | 接收专注提醒 |
| 阶段 8: 完善 | 7 | 横切关注点 |
| **总计** | **60** | 完整功能实现 |

**MVP 范围 (阶段 1-3+5)**: 31 个任务 (包含基础无障碍)
