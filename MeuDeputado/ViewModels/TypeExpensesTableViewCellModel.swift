import Charts
import RxCocoa
import RxSwift
import RxSwiftExt

final class TypeExpensesTableViewCellModel: ViewModelType {

  struct Constants {}

  struct Input {
    let index: Observable<Double>
  }

  struct Output {
    let year: Driver<String>
    let type: Driver<String?>
    let dataSet: Driver<ExpensesLineChartDataSet>
    let value: Driver<String?>
    let months: Driver<[String]>
    let index: Driver<Int>
    let entry: Driver<ExpensesLineChartDataSet>
  }

  private let year: BehaviorSubject<Int>
  private var months = [String]()
  private var values = [Decimal]()
  private var type: String?
  private var entries = [ChartDataEntry]()
  private var dataSet: ExpensesLineChartDataSet?

  private var _initialIndex = 0
  private var initialIndex: Observable<Int> {
    .just(_initialIndex)
  }

  init(
    year: BehaviorSubject<Int>,
    expenses: [Expense]
  ) {
    self.year = year

    let expensesWithMonthsMapped: [(month: String, value: Decimal)] = mapMonths(expenses)
    months = expensesWithMonthsMapped.map { $0.month }
    values = expensesWithMonthsMapped.map { $0.value }
    type = expenses.first?.detail

    let entries = mapEntries(expensesWithMonthsMapped)
    self.entries = entries
    dataSet = ExpensesLineChartDataSet(entries: entries, drawCirclesEnabled: false)
  }

  private func mapMonths(
    _ expenses: [Expense]
  ) -> [(String, Decimal)] {
    let expenses = fillMissingMonths(expenses)

    // FIXME: Use cache
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "pt_BR")

    return
      expenses
      .sorted { $0.month < $1.month }
      .map { expense -> (month: String, value: Decimal) in
        let month = formatter.monthSymbols[expense.month - 1].prefix(3).uppercased()
        return (month, expense.value)
      }
  }

  private func fillMissingMonths(
    _ expenses: [Expense]
  ) -> [Expense] {
    guard let _expense = expenses.first else { return expenses }
    var expenses = expenses
    // FIXME: Not safe
    let currentMonth = Calendar.current.component(.month, from: Date())

    let allMonthsSoFar = Set(Array(1...currentMonth))
    let expensesMonths = Set(expenses.map { $0.month })
    let difference = Array(expensesMonths.symmetricDifference(allMonthsSoFar))

    difference.forEach {
      let expense = Expense(code: _expense.code, detail: _expense.detail, value: 0.0, month: $0)
      expenses.append(expense)
    }

    return expenses
  }

  private func mapEntries(
    _ expenses: [(month: String, value: Decimal)]
  ) -> [ChartDataEntry] {
    expenses.enumerated().map { (offset, element) -> ChartDataEntry in
      ChartDataEntry(x: Double(offset), y: Double(truncating: element.value as NSNumber))
    }
  }

  private func formatCurrency(
    _ valuesWithIndex: (values: [Decimal], index: Int)
  ) -> String? {
    let value = valuesWithIndex.values[valuesWithIndex.index]

    // FIXME: Use cache
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.numberStyle = .currency
    let valueFormatted = formatter.string(from: value as NSNumber)
    return valueFormatted
  }

  func transform(input: Input) -> Output {

    let _index = input.index
      .map(Int.init)
      .do(onNext: { [unowned self] in self._initialIndex = $0 })

    let index = Observable.merge(initialIndex, _index)

    let value = Observable.combineLatest(Observable.just(values), index)
      .map(formatCurrency)
      .asDriverOnErrorJustComplete()

    let entry = Observable.combineLatest(Observable.just(entries), index)
      .map { [$0.0[$0.1]] }
      .map { ExpensesLineChartDataSet(entries: $0, drawCirclesEnabled: true) }
      .asDriverOnErrorJustComplete()

    let year = self.year
      .map { String($0) }
      .take(1)
      .asDriverOnErrorJustComplete()

    let dataSet = Observable.just(self.dataSet)
      .unwrap()
      .asDriverOnErrorJustComplete()

    return Output(
      year: year,
      type: .just(self.type),
      dataSet: dataSet,
      value: value,
      months: .just(self.months),
      index: index.asDriverOnErrorJustComplete(),
      entry: entry
    )
  }
}
