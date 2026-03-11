# 快速开始指南：Forest Focus Timer

## 前置条件

- macOS 14.0+ (Sonoma)
- Xcode 15.0+
- iOS 17.0+ 模拟器或真机
- Swift 5.9+

## 构建步骤

1. **克隆仓库**
   ```bash
   git clone <repository-url>
   cd grove
   ```

2. **打开项目**
   ```bash
   open ForestFocusTimer.xcodeproj
   ```

3. **选择目标设备**
   - 推荐：iPhone 15 Pro 模拟器
   - 最低支持：iPhone XS (iOS 17.0)

4. **构建并运行**
   - 快捷键：`Cmd + R`
   - 或点击 Xcode 工具栏运行按钮

## 运行测试

### 单元测试
```bash
xcodebuild test \
  -scheme ForestFocusTimer \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  --test-iterations 3
```

### UI 测试
```bash
xcodebuild test \
  -scheme ForestFocusTimer \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:ForestFocusTimerTests/Integration
```

## 性能基准测试

### 冷启动时间
```bash
# 使用 Xcode Instruments 的 Launch Time 模板
# 目标：从点击图标到主界面可交互 < 2 秒
```

### 内存占用
```bash
# 使用 Xcode Instruments 的 Allocations 模板
# 目标：运行期间内存占用 < 50MB
```

### 帧率检测
```bash
# 使用 Xcode Instruments 的 Core Animation 模板
# 目标：动画期间 FPS 保持在 60
```

## 无障碍访问测试

### VoiceOver 测试
1. 打开设置 > 辅助功能 > VoiceOver
2. 开启 VoiceOver
3. 测试所有界面元素的朗读准确性

### 动态字体测试
1. 打开设置 > 显示与亮度 > 文字大小
2. 调整到最大 (200%)
3. 验证布局不崩坏

## 常见问题

**Q: 模拟器无法启动？**
A: 确保 Xcode Command Line Tools 已安装：`xcode-select --install`

**Q: 测试失败？**
A: 清理构建缓存：`Cmd + Shift + K` 然后重新构建

**Q: SwiftData 模型迁移错误？**
A: 删除模拟器应用后重新安装，或重置模拟器内容

## 下一步

完成快速开始后，继续执行 `/speckit.tasks` 生成任务列表。
