import Foundation
import RxSwift
import RxDataSources

enum ExpensesSectionItem {
    case total(viewModel: TotalExpensesTableViewCellModel)
    case type(viewModel: TypeExpensesTableViewCellModel)
}

enum ExpensesSectionModel {
    case total(items: [ExpensesSectionItem])
    case type(items: [ExpensesSectionItem])
}

extension ExpensesSectionModel: SectionModelType {
    typealias Item = ExpensesSectionItem
    
    var items: [ExpensesSectionItem] {
        switch self {
            case .total(items: let items):
                return items.map { $0 }
            case .type(items: let items):
                return items.map { $0 }
        }
    }
    
    init(original: ExpensesSectionModel, items: [Item]) {
        switch original {
            case let .total(items: items):
                self = .total(items: items)
            case .type(items: let items):
                self = .total(items: items)
        }
    }
}
