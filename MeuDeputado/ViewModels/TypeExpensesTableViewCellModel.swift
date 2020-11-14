import RxSwift
import RxCocoa
import RxSwiftExt
import Charts

final class TypeExpensesTableViewCellModel: ViewModelType {

    struct Constants { }
    
    struct Input {
        let index: Observable<Double>
    }
    
    struct Output {
        let year: Driver<String>
        let type: Driver<String>
        let dataSet: Driver<ExpensesLineChartDataSet>
        let value: Driver<String?>
        let months: Driver<[String]>
        let index: Driver<Int>
        let entry: Driver<ExpensesLineChartDataSet>
    }
    
    private let year: BehaviorSubject<Int>
    private let expenses: [Expense]
    
    init(
        year: BehaviorSubject<Int>,
        expenses: [Expense]
    ) {
        self.year = year
        self.expenses = expenses
    }
    
    private func mapMonths(
        _ expenses: [Expense]
    ) -> [(String, Decimal)] {
        // FIXME: Use cache
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        
        return expenses
            .sorted { $0.month < $1.month }
            .map { expense -> (month: String, value: Decimal) in
                let month = formatter.monthSymbols[expense.month - 1].prefix(3).uppercased()
                return (month, expense.value)
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
        
        let expensesWithMonthsMapped = mapMonths(expenses)
        let chartEntries = mapEntries(expensesWithMonthsMapped)
        let dataSet = ExpensesLineChartDataSet(entries: chartEntries, drawCirclesEnabled: false)
        
        let entries = Observable.just(chartEntries)
        
        let expenses = Observable.just(expensesWithMonthsMapped)
        
        let index = input.index
            .map(Int.init)
            .startWith(0)
        
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
        
        let type = Observable.just(self.expenses)
            .map { $0.first?.detail }
            .unwrap()
            .asDriverOnErrorJustComplete()
        
        let year = self.year
            .map { String($0) }
            .take(1)
            .asDriverOnErrorJustComplete()
        
        return Output(
            year: year,
            type: type,
            dataSet: .just(dataSet),
            value: value,
            months: months,
            index: index.asDriverOnErrorJustComplete(),
            entry: entry
        )
    }
}
