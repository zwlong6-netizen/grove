import SwiftUI

/// 树木网格布局组件
///
/// 在森林视图中以响应式网格显示树木
struct TreeGridView: View {
    let trees: [Tree]
    var onTreeTap: ((Tree) -> Void)?
    var onLongPress: ((Tree) -> Void)?

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(trees, id: \.id) { tree in
                    TreeGridItem(tree: tree)
                        .onTapGesture {
                            onTreeTap?(tree)
                        }
                        .onLongPressGesture {
                            onLongPress?(tree)
                        }
                }
            }
            .padding(.vertical, 8)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("树木网格")
    }
}

// MARK: - Tree Grid Item

struct TreeGridItem: View {
    let tree: Tree

    var body: some View {
        VStack(spacing: 8) {
            // 树木图标
            ZStack {
                Circle()
                    .fill(Color.appPrimary.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.appPrimary)
            }

            // 时长标签
            Text(formatDuration(tree.durationSeconds))
                .font(.caption2)
                .foregroundColor(Color.appSecondaryText)
        }
        .padding(.vertical, 12)
        .background(Color.appCardBackground)
        .cornerRadius(12)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return "\(minutes)分钟"
    }
}

// MARK: - Preview

#Preview("树木网格") {
    TreeGridView(
        trees: [
            Tree(plantedDate: Date(), durationSeconds: 25 * 60),
            Tree(plantedDate: Date().addingTimeInterval(-86400), durationSeconds: 45 * 60),
            Tree(plantedDate: Date().addingTimeInterval(-86400 * 2), durationSeconds: 25 * 60),
            Tree(plantedDate: Date().addingTimeInterval(-86400 * 3), durationSeconds: 60 * 60),
            Tree(plantedDate: Date().addingTimeInterval(-86400 * 4), durationSeconds: 25 * 60),
            Tree(plantedDate: Date().addingTimeInterval(-86400 * 5), durationSeconds: 15 * 60),
        ]
    )
    .padding()
    .background(Color.appBackground)
}
