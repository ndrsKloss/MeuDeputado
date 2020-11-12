import RxCocoa
import Charts

final class TotalExpensesTableViewCellModel: ViewModelType {

    struct Constants { }
    
    struct Input { }
    
    struct Output {
        let title: Driver<String>
        let information: Driver<String>
        let chartEntries: Driver<[ChartDataEntry]>
    }
    
    private let title: String
    private let information: String
    private let expensesInformation: [Int: [ExpenseInformation]]
    
    init(
        title: String,
        information: String,
        expensesInformation: [Int: [ExpenseInformation]]
    ) {
        self.title = title
        self.information = information
        self.expensesInformation = expensesInformation
    }

    private func groupExpensesByMonth(
        _ expensesInformation: [Int: [ExpenseInformation]]
    ) -> [Int: [Decimal]] {
        expensesInformation
            .flatMap { $0.value }
            .reduce(into: [Int: [Decimal]]()) { acc, cur in
                let existing = acc[cur.month] ?? []
                acc[cur.month] = existing + [cur.value]
            }
    }
    
    private func totalExpesesByMonth(
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
    
    func transform(input: Input) -> Output {

        let expensesGroupedByMonth = groupExpensesByMonth(expensesInformation)
        let totalGroupedExpesesesByMonth = totalExpesesByMonth(expensesGroupedByMonth)
        let expensesWithMonthsMapped = mapMonths(totalGroupedExpesesesByMonth)
        let chartEntries = mapEntries(expensesWithMonthsMapped)

        return Output (
            title: .just(title),
            information: .just(information),
            chartEntries: .just(chartEntries)
        )
    }
}
