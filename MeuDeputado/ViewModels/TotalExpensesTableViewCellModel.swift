import RxSwift
import RxCocoa
import Charts

final class TotalExpensesTableViewCellModel: ViewModelType {

    struct Constants {
        static let expenseType = NSLocalizedString("Total-Expenses", comment: "")
    }
    
    struct Input {
        let index: Observable<Double>
    }
    
    struct Output {
        let year: Driver<String>
        let information: Driver<String>
        let dataSet: Driver<ExpensesLineChartDataSet>
        let value: Driver<String?>
        let months: Driver<[String]>
        let index: Driver<Int>
        let entry: Driver<ExpensesLineChartDataSet>
    }
    
    private let year: BehaviorSubject<Int>
    private let information: String
    private var months = [String]()
    private var values = [Decimal]()
    private var entries = [ChartDataEntry]()
    private var dataSet: ExpensesLineChartDataSet?
    
    private var _initialIndex = 0
    private var initialIndex: Observable<Int> {
        .just(_initialIndex)
    }
    
    init(
        year: BehaviorSubject<Int>,
        information: String,
        expense: [Int: [Expense]]
    ) {
        self.year = year
        self.information = information
        
        let expensesGroupedByMonth = groupExpensesByMonth(expense)
        let totalGroupedExpesesesByMonth = totalExpensesByMonth(expensesGroupedByMonth)
        let expensesWithMonthsMapped: [(month: String, value: Decimal)] = mapMonths(totalGroupedExpesesesByMonth)
        months = expensesWithMonthsMapped.map { $0.month }
        values = expensesWithMonthsMapped.map { $0.value }
        let entries = mapEntries(expensesWithMonthsMapped)
        self.entries = entries
        dataSet = ExpensesLineChartDataSet(entries: entries, drawCirclesEnabled: false)
    }

    private func groupExpensesByMonth(
        _ expense: [Int: [Expense]]
    ) -> [Int: [Decimal]] {
        expense
            .flatMap { $0.value }
            .reduce(into: [Int: [Decimal]]()) { acc, cur in
                let existing = acc[cur.month] ?? []
                acc[cur.month] = existing + [cur.value]
            }
    }
    
    private func totalExpensesByMonth(
        _ expesesGrouped: [Int: [Decimal]]
    ) -> [Int: Decimal] {
        expesesGrouped
            .reduce(into: [Int: Decimal]()) { values, expenses in
                values[expenses.key] = expenses.value.reduce(0, +)
            }
    }
    
    private func mapMonths(
        _ expenses: [Int: Decimal]
    ) -> [(String, Decimal)] {
        let expenses = fillMissingMonths(expenses)
        
        // FIXME: Use cache
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        
        return expenses
            .sorted { $0.key < $1.key }
            .map { (key, value) -> (month: String, value: Decimal) in
                let month = formatter.monthSymbols[key - 1].prefix(3).uppercased()
                return (month, value)
            }
    }
    
    private func fillMissingMonths(
        _ expenses: [Int: Decimal]
    ) -> [Int: Decimal] {
        var expenses = expenses
                
        // FIXME: Not safe
        let currentMonth = Calendar.current.component(.month, from: Date())

        let allMonthsSoFar = Set(Array(1...currentMonth))
        let expensesMonths = Set(expenses.map { $0.key })
        let difference = Array(expensesMonths.symmetricDifference(allMonthsSoFar))
        
        difference.forEach { expenses[$0] = Decimal(0.0) }
        
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
        // TODO: Update date from input and make request
        
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

        return Output (
            year: year,
            information: .just(information),
            dataSet: dataSet,
            value: value,
            months: .just(months),
            index: index.asDriverOnErrorJustComplete(),
            entry: entry
        )
    }
}
