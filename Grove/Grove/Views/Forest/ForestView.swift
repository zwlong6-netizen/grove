import SwiftUI
import SwiftData

/// 森林视图
///
/// 以网格布局展示用户所有已完成的树木
struct ForestView: View {
    @StateObject private var viewModel: ForestViewModel
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTree: Tree?
    @State private var showDeleteAllConfirm = false

    init(viewModel: ForestViewModel = ForestViewModel(modelContext: .init())) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 16) {
            // 导航栏
            navigationBar

            // 统计摘要
            statisticsSummary

            // 树木网格
            if viewModel.isLoading {
                loadingView
            } else if viewModel.trees.isEmpty {
                emptyStateView
            } else {
                treeGridView
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.appBackground)
        .sheet(item: $selectedTree) { tree in
            TreeDetailView(tree: tree)
        }
        .sheet(isPresented: $showDeleteAllConfirm) {
            DeleteAllConfirmationView(
                onConfirm: {
                    viewModel.deleteAllTrees()
                    showDeleteAllConfirm = false
                },
                onCancel: {
                    showDeleteAllConfirm = false
                }
            )
        }
        .onAppear {
            viewModel.loadTrees()
        }
        .refreshable {
            viewModel.loadTrees()
        }
    }

    // MARK: - Subviews

    private var navigationBar: some View {
        HStack {
            Text("我的森林")
                .appTitleFont()
                .foregroundColor(Color.appPrimaryText)

            Spacer()

            // 排序按钮
            Button(action: {
                viewModel.toggleSort()
            }) {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(Color.appPrimary)
            }
            .accessibilityButton(label: "排序按钮")

            // 更多操作按钮
            Menu {
                Button("清空森林", role: .destructive) {
                    showDeleteAllConfirm = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color.appPrimaryText)
            }
        }
        .padding(.top, 8)
    }

    private var statisticsSummary: some View {
        HStack(spacing: 16) {
            StatCard(
                title: "总树木",
                value: "\(viewModel.totalTreesCount)",
                icon: "leaf.fill"
            )

            StatCard(
                title: "总时长",
                value: viewModel.formattedTotalTime,
                icon: "clock.fill"
            )
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("正在加载森林...")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.arrow.circle")
                .font(.system(size: 60))
                .foregroundColor(Color.appSecondaryText.opacity(0.5))

            Text("还没有树木")
                .appSubtitleFont()
                .foregroundColor(Color.appPrimaryText)

            Text("完成一次专注，种下第一棵树")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var treeGridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(viewModel.trees, id: \.id) { tree in
                    TreeGridItem(tree: tree)
                        .onTapGesture {
                            selectedTree = tree
                        }
                        .accessibilityButton(
                            label: "树木详情",
                            hint: "种植于 \(tree.plantedDate.formatted())"
                        )
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

// MARK: - Delete All Confirmation

struct DeleteAllConfirmationView: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("确定要清空森林吗？")
                .appTitleFont()
                .foregroundColor(Color.appPrimaryText)

            Text("此操作将删除所有树木记录\n且无法恢复")
                .appBodyFont()
                .foregroundColor(Color.appSecondaryText)
                .multilineTextAlignment(.center)

            Button(action: onConfirm) {
                Text("确认清空")
                    .appButtonFont()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(action: onCancel) {
                Text("取消")
                    .appBodyFont()
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .padding(32)
        .background(Color.appCardBackground)
        .cornerRadius(20)
        .padding(.horizontal, 40)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ForestView()
    }
    .modelContainer(for: [FocusSession.self, Tree.self], inMemory: true)
}
