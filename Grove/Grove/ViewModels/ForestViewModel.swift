import Foundation
import SwiftData
import Combine

/// 森林视图模型
///
/// 负责管理个人森林的数据加载和管理
@MainActor
class ForestViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var trees: [Tree] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var sortBy: SortOption = .date

    // MARK: - Properties

    private let modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Sort Options

    enum SortOption: String, CaseIterable {
        case date = "date"
        case duration = "duration"

        var displayName: String {
            switch self {
            case .date: return "日期"
            case .duration: return "时长"
            }
        }
    }

    // MARK: - Init

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Public Methods

    /// 加载森林数据
    func loadTrees() {
        isLoading = true

        do {
            let descriptor = FetchDescriptor<Tree>(
                predicate: #Predicate { $0.isDeleted == false },
                sortBy: sortDescriptors
            )
            trees = try modelContext.fetch(descriptor)
            isLoading = false
        } catch {
            showError = true
            errorMessage = "加载森林失败：\(error.localizedDescription)"
            isLoading = false
        }
    }

    /// 删除树木
    func deleteTree(_ tree: Tree) {
        do {
            tree.isDeleted = true
            tree.updatedAt = Date()
            try modelContext.save()
            loadTrees() // 重新加载
        } catch {
            showError = true
            errorMessage = "删除失败：\(error.localizedDescription)"
        }
    }

    /// 清空所有树木
    func deleteAllTrees() {
        do {
            let descriptor = FetchDescriptor<Tree>(
                predicate: #Predicate { $0.isDeleted == false }
            )
            let allTrees = try modelContext.fetch(descriptor)

            for tree in allTrees {
                tree.isDeleted = true
                tree.updatedAt = Date()
            }

            try modelContext.save()
            loadTrees()
        } catch {
            showError = true
            errorMessage = "清空失败：\(error.localizedDescription)"
        }
    }

    /// 切换排序方式
    func toggleSort() {
        guard let currentIndex = SortOption.allCases.firstIndex(of: sortBy) else {
            sortBy = .date
            return
        }

        let nextIndex = (currentIndex + 1) % SortOption.allCases.count
        sortBy = SortOption.allCases[nextIndex]
        loadTrees()
    }

    // MARK: - Private Methods

    private var sortDescriptors: [SortDescriptor<Tree>] {
        switch sortBy {
        case .date:
            return [SortDescriptor(\.plantedDate, order: .reverse)]
        case .duration:
            return [SortDescriptor(\.durationSeconds, order: .reverse)]
        }
    }
}

// MARK: - Statistics Computation

extension ForestViewModel {
    /// 总树木数
    var totalTreesCount: Int {
        trees.count
    }

    /// 总专注时间（秒）
    var totalFocusTime: Int {
        trees.reduce(0) { $0 + $1.durationSeconds }
    }

    /// 格式化总时间
    var formattedTotalTime: String {
        let hours = totalFocusTime / 3600
        let minutes = (totalFocusTime % 3600) / 60
        if hours > 0 {
            return "\(hours)小时\(minutes)分钟"
        } else {
            return "\(minutes)分钟"
        }
    }
}
