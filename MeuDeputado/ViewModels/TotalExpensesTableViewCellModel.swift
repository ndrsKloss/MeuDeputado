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
    private let expense: [Int: [Expense]]
    
    init(
        year: BehaviorSubject<Int>,
        information: String,
        expense: [Int: [Expense]]
    ) {
        self.year = year
        self.information = information
        self.expense = expense
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
        
        let expensesGroupedByMonth = groupExpensesByMonth(expense)
        let totalGroupedExpesesesByMonth = totalExpensesByMonth(expensesGroupedByMonth)
        let expensesWithMonthsMapped = mapMonths(totalGroupedExpesesesByMonth)
        let chartEntries = mapEntries(expensesWithMonthsMapped)
        let dataSet = ExpensesLineChartDataSet(entries: chartEntries, drawCirclesEnabled: false)

        let index = input.index
            .map(Int.init)
            .startWith(0)
        
        let entries = Observable.just(chartEntries)
        
        let expenses = Observable.just(expensesWithMonthsMapped)
        
        let months = expenses
            .map { $0.map { $0.0 } }
            .asDriverOnErrorJustComplete()
        
        let values = expenses
            .map { $0.map { $0.1 } }
        
        let value = Observable.combineLatest(values, index)
            .map(formatCurrency)
            .asDriverOnErrorJustComplete()
        
        let entry = Observable.combineLatest(entries, index)
            .map { [$0.0[$0.1]] }
            .map { ExpensesLineChartDataSet(entries: $0, drawCirclesEnabled: true) }
            .asDriverOnErrorJustComplete()
        
        let year = self.year
            .map { String($0) }
            .take(1)
            .asDriverOnErrorJustComplete()
        
        return Output (
            year: year,
            information: .just(information),
            dataSet: .just(dataSet),
            value: value,
            months: months,
            index: index.asDriverOnErrorJustComplete(),
            entry: entry
        )
    }
}
