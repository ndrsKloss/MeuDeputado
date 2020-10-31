import RxCocoa
import RxSwift
import RxSwiftExt
import Parse

final class MainContainerViewModel: ViewModelType {
	
	typealias TransitionContent = MainContentViewModel.MainContent
	
	struct Constants {
		static let appName = NSLocalizedString("App-Name", comment: "")
	}
	
	struct Input {
		let viewWillAppear: ControlEvent<Bool>
		let retryTap: ControlEvent<Void>
		let leftTap: ControlEvent<Void>
		let rightTap: ControlEvent<Void>
	}
	
	struct Output {
		let deputyContent: Driver<MainContentViewModel>
		let partyContent: Driver<MainContentViewModel>
		let state: Driver<State>
	}
	
	enum State {
		case loading, success, error
	}
	
	private let finder: Fetchable

	private let disposeBag = DisposeBag()

	init(finder: Fetchable) {
		self.finder = finder
	}
	
	func transform(
		input: Input
	) -> Output {
		let activityIndicator = ActivityIndicator()
		let errorTracker = ErrorTracker()
		
		let viewWillAppear = input.viewWillAppear
			.take(1)
			.map { _ in () }
		
		let impulse = Observable.merge(viewWillAppear, input.retryTap.asObservable())

		let deputies = impulse
			.flatMapLatest(allDeputiesInMandate)
			.trackError(errorTracker)
			.catchErrorJustComplete()
			.trackActivity(activityIndicator)
		
		let parties = impulse
			.flatMapLatest(allParties)
			.trackError(errorTracker)
			.trackActivity(activityIndicator)
		
		let deputiesAndParties = Observable.combineLatest(deputies, parties)
			.map { (deputies: $0.0, parties: $0.1) }
			.share()
		
		let deputyContent = deputiesAndParties
			.map { $0.deputies }
			.map(deputyToTransitionContent)
			.map(MainContentViewModel.init)
		
		let partyContent = deputiesAndParties
			.map { $0.parties }
			.map(partyToTransitionContent)
			.map(MainContentViewModel.init)
		
		let success = Observable.combineLatest(deputyContent, partyContent)
			.map { _ in State.success }
		
		let error = errorTracker
			.asObservable()
			.map { _ in State.error }
		
		let loading = activityIndicator
			.asObservable()
			.filter { $0 }
			.map { _ in State.loading }
		
		let state = Observable.merge(success, error, loading)
			.asDriverOnErrorJustComplete()
			
		return Output(
			deputyContent: deputyContent.asDriverOnErrorJustComplete(),
			partyContent: partyContent.asDriverOnErrorJustComplete(),
			state: state
		)
	}
	
	private func allDeputiesInMandate() -> Observable<[Deputy]> {
		finder.find(query: getAllDeputiesInMandateQuery)
			.asObservable()
			.map { $0 as? [Deputy] }
			.unwrap()
	}
	
	private func allParties() -> Observable<[Party]> {
		finder.find(query: getAllParties)
			.asObservable()
			.map { $0 as? [Party] }
			.unwrap()
	}
	
	private func deputyToTransitionContent(
		deputies: [Deputy]
	) -> [TransitionContent] {
		deputies.map { TransitionContent(title: $0.name, information: $0.party, imageId: $0.objectId) }
	}
	
	private func partyToTransitionContent(
		party: [Party]
	) -> [TransitionContent] {
		party.map { TransitionContent(title: $0.name, information: $0.deputyCount.description) }
	}
}

