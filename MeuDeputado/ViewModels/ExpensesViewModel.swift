import RxSwift
import Parse

final class ExpensesViewModel: ViewModelType {
	
	struct Constants {
		static let currentLegislature = [2018, 2019, 2020, 2021]
	}
	
	
	
	struct Input {
		
	}
	
	struct Output { }
	
	private let content: MainContent
	private let finder: Fetchable
	
	var currentYear: Int {
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
		
		kind.filter { $0 == .deputy }
			.withLatestFrom(queryParameters)
			.flatMapLatest(deputyExpenses)
			.subscribe(onNext: { print($0) })
		
		kind.filter { $0 == .party }
			.withLatestFrom(queryParameters)
			.flatMapLatest(partyExpenses)
			.subscribe(onNext: { print($0) })
			
		return Output()
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
	
	private func deputyExpenses(
		year: Int,
		id: String?
	) -> Observable<[DeputyExpense]> {
		finder.find(query: getDeputyExpenses(year: NSNumber(value: year), objectId: id))
			.asObservable()
			.map { $0 as? [DeputyExpense] }
			.unwrap()
	}
}
