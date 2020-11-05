import RxSwift
import Parse

final class ExpensesViewModel: ViewModelType {
	
	struct Constants { }

	struct Input { }
	
	struct Output { }
	
	private let content: MainContent
	private let finder: Fetchable
	
	private var currentYear: Int {
		let date = Date()
		let calendar = Calendar(identifier: .gregorian)
		return calendar.component(.year, from: date)
	}
	
	init(
		content: MainContent,
		finder: Fetchable
	) {
		self.content = content
		self.finder = finder
	}
	
	func transform(input: Input) -> Output {
		let kind = Observable.just(content.model)
		let queryParameters = Observable.combineLatest(Observable.just(currentYear), Observable.just(content.id))
		
		let _deputyExpenses = kind.filter { $0 == .deputy }
			.withLatestFrom(queryParameters)
			.flatMapLatest(deputyExpenses)
			.map(deputyToExpenseContent)
		
		let _partyExpenses = kind.filter { $0 == .party }
			.withLatestFrom(queryParameters)
			.flatMapLatest(partyExpenses)
			.map(partyToExpenseContent)
		
		let expenses = Observable.merge(_deputyExpenses, _partyExpenses)
			.map { $0.sorted { $0.key > $1.key } }
			
			
		return Output()
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
	private func deputyToExpenseContent(expenses: [DeputyExpense]) -> [Int: [ExpenseInformation]] {
		let expensesInformation = expenses.map {
			ExpenseInformation(
				code: Int(truncating: $0.type.code),
				detail: $0.type.detail,
				value: Decimal(Int(truncating: $0.value)), month: Int(truncating: $0.month))
			}
		return groupExpensesByCode(expensesInformation)
	}
	
	private func partyToExpenseContent(expenses: [PartyExpense]) -> [Int: [ExpenseInformation]] {
		let expensesInformation = expenses.map {
			ExpenseInformation(
				code: Int(truncating: $0.expenseType.code),
				detail: $0.expenseType.detail,
				value: Decimal(Int(truncating: $0.value)), month: Int(truncating: $0.month))
			}
		return groupExpensesByCode(expensesInformation)
	}
	
	func groupExpensesByCode(_ expenses: [ExpenseInformation]) -> [Int: [ExpenseInformation]] {
		let empty: [Int: [ExpenseInformation]] = [:]
		
		return expenses.reduce(into: empty) { acc, cur in
			let existing = acc[cur.code] ?? []
			acc[cur.code] = existing + [cur]
		}
	}
}
