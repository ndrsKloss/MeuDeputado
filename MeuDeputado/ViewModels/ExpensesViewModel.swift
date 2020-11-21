import RxSwift
import RxCocoa
import Parse

final class ExpensesViewModel: ViewModelType {
	
    enum Destination {
        case toComparation
    }
    
	struct Constants { }

	struct Input { }
    
	struct Output {
        let title: Driver<String>
        let dataSource: Driver<[ExpensesSectionModel]>
    }
	
	private let content: MainContent
	private let finder: Fetchable
    private let contentTocompare: PublishSubject<MainContent>

    private let year: BehaviorSubject<Int>
    
    private var totalExpenses = [[Int: [Expense]]]()
    private let navigationPublisher = PublishSubject<Pilot<Destination>>()
    
    var navigation: Driver<Pilot<Destination>> {
        navigationPublisher.asDriverOnErrorJustComplete()
    }

	init(
		content: MainContent,
		finder: Fetchable,
        contentTocompare: PublishSubject<MainContent>
	) {
		self.content = content
		self.finder = finder
        self.contentTocompare = contentTocompare
        
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        
        self.year = BehaviorSubject<Int>(value: year)
	}
	
	func transform(input: Input) -> Output {
        
        //let contentModel = Observable.just(content.model)
        
        let contentModelFromCompare = contentTocompare.map { $0.model }
        let contentModelFromInit = Observable.just(content.model)
        
        let contentModel = Observable.merge(contentModelFromCompare, contentModelFromInit)
            .share()
        
		let queryParameters = Observable.combineLatest(year, Observable.just(content.id))

		let _deputyExpenses = contentModel
            .filter { $0 == .deputy }
			.withLatestFrom(queryParameters)
            .flatMapLatest(deputyExpenses)
			.map(deputyToExpenseContent)
		
		let _partyExpenses = contentModel
            .filter { $0 == .party }
			.withLatestFrom(queryParameters)
			.flatMapLatest(partyExpenses)
			.map(partyToExpenseContent)
		
        let expenses = Observable.merge(_deputyExpenses, _partyExpenses)
            .share()
        
        let total = expenses
            .map(totalExpensesCellModel)
        
        let types = expenses
            .map(typeExpensesCellModel)

        let dataSource = Observable.combineLatest(total, types) { $0 + $1 }
            .asDriverOnErrorJustComplete()

        return Output(
            title: .just(content.title),
            dataSource: dataSource
        )
	}
}

extension ExpensesViewModel {
	private func deputyExpenses(
		year: Int,
		id: String?
	) -> Observable<[DeputyExpense]> {
		finder.find(query: getDeputyExpenses(year: NSNumber(value: year), objectId: id))
			.asObservable()
			.map { $0 as? [DeputyExpense] }
			.unwrap()
	}
	
	private func partyExpenses(
		year: Int,
		id: String?
	) -> Observable<[PartyExpense]> {
		finder.find(query: getPartyExpenses(year: NSNumber(value: year), objectId: id))
			.asObservable()
			.map { $0 as? [PartyExpense] }
			.unwrap()
	}
}

extension ExpensesViewModel {
	private func deputyToExpenseContent(
        expenses: [DeputyExpense]
    ) -> [Int: [Expense]] {
		let expense = expenses.map {
			Expense(
				code: Int(truncating: $0.type.code),
				detail: $0.type.detail,
				value: Decimal(Int(truncating: $0.value)), month: Int(truncating: $0.month))
			}
		return groupExpensesByCode(expense)
	}
	
	private func partyToExpenseContent(
        expenses: [PartyExpense]
    ) -> [Int: [Expense]] {
		let expense = expenses.map {
			Expense(
				code: Int(truncating: $0.expenseType.code),
				detail: $0.expenseType.detail,
				value: Decimal(Int(truncating: $0.value)), month: Int(truncating: $0.month))
			}
		return groupExpensesByCode(expense)
	}
	
	private func groupExpensesByCode(
        _ expenses: [Expense]
    ) -> [Int: [Expense]] {
		expenses.reduce(into: [Int: [Expense]]()) { acc, cur in
			let existing = acc[cur.code] ?? []
			acc[cur.code] = existing + [cur]
		}
	}

    private func totalExpensesCellModel(
        _ expenses: [Int: [Expense]]
    ) -> [ExpensesSectionModel] {
        
        totalExpenses.append(expenses)
        
        let viewModel = TotalExpensesTableViewCellModel(
            year: year,
            information: content.information,
            expense: /*expenses*/ totalExpenses[0],
            navigation: navigationPublisher
        )
        let item = ExpensesSectionItem.total(viewModel: viewModel)
        let section = ExpensesSectionModel.total(items: [item])
        return [section]
    }
    
    private func typeExpensesCellModel(
        _ expenses: [Int: [Expense]]
    ) -> [ExpensesSectionModel] {
        
        
        
        let items = expenses
            .sorted { $0.key < $1.key }
            .map {
                TypeExpensesTableViewCellModel(year: year, expenses: $0.value)
                }
            .map { ExpensesSectionItem.type(viewModel: $0) }
        
        let section = ExpensesSectionModel.type(items: items)
        return [section]
    }
}
