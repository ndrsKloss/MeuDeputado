import RxSwift
import RxCocoa
import Charts

final class TypeExpensesTableViewCellModel: ViewModelType {

    struct Constants { }
    
    struct Input { }
    
    struct Output { }
    
    private let year: BehaviorSubject<Int>
    private let expensesInformation: [ExpenseInformation]
    
    init(
        year: BehaviorSubject<Int>,
        expensesInformation: [ExpenseInformation]
    ) {
        self.year = year
        self.expensesInformation = expensesInformation
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
