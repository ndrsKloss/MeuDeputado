import RxSwift
import RxCocoa
import Charts

final class TypeExpensesTableViewCellModel: ViewModelType {

    struct Constants { }
    
    struct Input { }
    
    struct Output { }
    
    private let year: BehaviorSubject<Int>
    private let expense: [Expense]
    
    init(
        year: BehaviorSubject<Int>,
        expense: [Expense]
    ) {
        self.year = year
        self.expense = expense
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
