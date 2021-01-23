import Foundation

struct Expense: Hashable {
  let code: Int
  let detail: String
  let value: Decimal
  let month: Int
}
