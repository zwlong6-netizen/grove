import SwiftUI

/// 树木生长视图
///
/// 根据专注进度显示 5 个生长阶段的 2D 矢量插画风格树木
/// 使用静态图片切换，每个阶段有明显的视觉差异
struct TreeGrowthView: View {
    /// 当前生长阶段 (0-4)
    let stage: Int
    /// 生长进度 (0.0-1.0)
    let progress: Double

    var body: some View {
        ZStack {
            // 背景光晕
            growthHalo

            // 树木主体
            treeBody

            // 地面
            ground
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .accessibilityImage(
            label: "树木生长阶段：\(currentStage.displayName), \(currentStage.description)",
            isDecorative: false
        )
    }

    // MARK: - Computed Properties

    private var currentStage: TreeStage {
        TreeStage.allCases[safe: stage] ?? .seed
    }

    private var scale: CGFloat {
        currentStage.sizeRatio
    }

    // MARK: - Subviews

    private var growthHalo: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        currentStage.primaryColor.opacity(0.3),
                        currentStage.primaryColor.opacity(0.1),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 50 * scale,
                    endRadius: 150 * scale
                )
            )
            .frame(width: 300, height: 300)
            .scaleEffect(scale)
            .animation(.easeOut(duration: 0.5), value: stage)
    }

    private var treeBody: some View {
        Group {
            switch stage {
            case 0:
                SeedView()
            case 1:
                SproutView()
            case 2:
                SaplingView()
            case 3:
                YoungTreeView()
            case 4:
                MatureTreeView()
            default:
                SeedView()
            }
        }
        .scaleEffect(scale)
        .foregroundColor(currentStage.primaryColor)
        .animation(.easeOut(duration: 0.5), value: stage)
    }

    private var ground: some View {
        Ellipse()
            .fill(Color(red: 0.4, green: 0.25, blue: 0.15).opacity(0.8))
            .frame(width: 200, height: 40)
            .offset(y: 120)
    }
}

// MARK: - Stage Views

/// 阶段 0: 种子
struct SeedView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(TreeStage.seed.primaryColor)
                .frame(width: 30, height: 30)
        }
        .offset(y: 80)
    }
}

/// 阶段 1: 嫩芽
struct SproutView: View {
    var body: some View {
        ZStack {
            // 茎
            RoundedRectangle(cornerRadius: 3)
                .fill(TreeStage.sprout.primaryColor)
                .frame(width: 6, height: 40)
                .offset(y: 60)

            // 叶子
            LeafView()
                .rotationEffect(.degrees(-30))
                .offset(x: -15, y: 50)

            LeafView()
                .rotationEffect(.degrees(30))
                .offset(x: 15, y: 50)
        }
    }
}

/// 阶段 2: 幼苗
struct SaplingView: View {
    var body: some View {
        ZStack {
            // 茎
            RoundedRectangle(cornerRadius: 4)
                .fill(TreeStage.sapling.primaryColor)
                .frame(width: 8, height: 60)
                .offset(y: 50)

            // 树枝
            BranchView()
                .rotationEffect(.degrees(-45))
                .offset(x: -20, y: 30)

            BranchView()
                .rotationEffect(.degrees(45))
                .offset(x: 20, y: 30)

            // 顶部叶子簇
            FoliarageView(size: 40)
                .offset(y: -10)
        }
    }
}

/// 阶段 3: 青年树
struct YoungTreeView: View {
    var body: some View {
        ZStack {
            // 树干
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.brown)
                .frame(width: 12, height: 80)
                .offset(y: 40)

            // 树冠下层
            FoliarageView(size: 60)
                .offset(y: 20)

            // 树冠上层
            FoliarageView(size: 50)
                .offset(y: -20)
        }
    }
}

/// 阶段 4: 成熟树
struct MatureTreeView: View {
    var body: some View {
        ZStack {
            // 树干
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.brown)
                .frame(width: 16, height: 100)
                .offset(y: 50)

            // 主树冠
            FoliarageView(size: 90)
                .offset(y: -10)

            // 侧边树冠
            FoliarageView(size: 60)
                .offset(x: -50, y: 10)

            FoliarageView(size: 60)
                .offset(x: 50, y: 10)

            // 顶部树冠
            FoliarageView(size: 50)
                .offset(y: -50)
        }
    }
}

// MARK: - Component Views

/// 叶子组件
struct LeafView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: 20, y: 10),
                control: CGPoint(x: 10, y: -5)
            )
            path.addQuadCurve(
                to: CGPoint(x: 0, y: 0),
                control: CGPoint(x: 10, y: 15)
            )
        }
        .fill(TreeStage.sprout.accentColor)
        .frame(width: 20, height: 10)
    }
}

/// 树枝组件
struct BranchView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(TreeStage.sapling.primaryColor)
            .frame(width: 4, height: 30)
    }
}

/// 叶簇组件
struct FoliarageView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(TreeStage.mature.primaryColor)
                .frame(width: size * 0.8, height: size * 0.8)

            Circle()
                .fill(TreeStage.mature.accentColor)
                .frame(width: size * 0.6, height: size * 0.6)
                .offset(x: -size * 0.15, y: -size * 0.1)

            Circle()
                .fill(TreeStage.mature.accentColor)
                .frame(width: size * 0.5, height: size * 0.5)
                .offset(x: size * 0.15, y: -size * 0.1)
        }
    }
}

// MARK: - Preview

#Preview {
    TreeGrowthView(stage: 4, progress: 1.0)
        .padding()
        .background(Color.appBackground)
}
