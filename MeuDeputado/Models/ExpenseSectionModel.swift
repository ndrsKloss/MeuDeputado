import Foundation
import RxDataSources
import RxSwift

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
    case .total(let items):
      return items.map { $0 }
    case .type(let items):
      return items.map { $0 }
    }
  }

  init(original: ExpensesSectionModel, items: [Item]) {
    switch original {
    case let .total(items: items):
      self = .total(items: items)
    case .type(let items):
      self = .total(items: items)
    }
  }
}
