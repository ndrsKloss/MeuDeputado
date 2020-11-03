import RxCocoa
import RxSwift
import RxSwiftExt
import Parse

final class MainContainerViewModel: ViewModelType {
	
	enum Destination {
        case expenses
    }
	
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
		let status: Driver<Status>
	}
	
	enum Status {
		case loading, success, error
	}
	
	private let finder: Fetchable

	private let disposeBag = DisposeBag()
	private let navigationPublisher = PublishSubject<Pilot<Destination>>()
	
	var navigation: Driver<Pilot<Destination>> {
		navigationPublisher.asDriverOnErrorJustComplete()
    }
	
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
			.catchErrorJustComplete()
			.trackActivity(activityIndicator)
		
		let deputiesAndParties = Observable.combineLatest(deputies, parties)
			.map { (deputies: $0.0, parties: $0.1) }
			.observeOn(MainScheduler.instance)
			.share()
		
		let deputyContent = deputiesAndParties
			.map { $0.deputies }
			.map(deputyToTransitionContent)
			.map(makeMainContentViewModel)
			.share()

		let partyContent = deputiesAndParties
			.map { $0.parties }
			.map(partyToTransitionContent)
			.map(makeMainContentViewModel)
			.share()
		
		let success = Observable.combineLatest(deputyContent, partyContent)
			.map { _ in Status.success }
		
		let error = errorTracker
			.asObservable()
			.map { _ in Status.error }
		
		let loading = activityIndicator
			.asObservable()
			.filter { $0 }
			.map { _ in Status.loading }
		
		let status = Observable.merge(success, error, loading)
			.asDriverOnErrorJustComplete()
			
		return Output(
			deputyContent: deputyContent.asDriverOnErrorJustComplete(),
			partyContent: partyContent.asDriverOnErrorJustComplete(),
			status: status
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
	) -> [MainContent] {
		deputies.map {
			MainContent(
				id: $0.objectId,
				title: $0.name,
				information: $0.party,
				represents: .deputy,
				imageId: $0.deputyId.description)
		}
	}
	
	private func partyToTransitionContent(
		party: [Party]
	) -> [MainContent] {
		party.map {
			MainContent(
				id: $0.objectId,
				title: $0.name,
				information: $0.deputyCount.description,
				represents: .party)
		}
	}
	
	private func makeMainContentViewModel(
		_ transitionContent: [MainContent]
	) -> MainContentViewModel {
		let viewModel = MainContentViewModel(content: transitionContent)

		viewModel.navigation
			.map { $0.getLuggage() }
			.unwrap()
			.map { (luggage: MainContent) in
				.init(destination: .expenses, luggage: luggage)
			}
			.drive(navigationPublisher)
			.disposed(by: disposeBag)
		
		return viewModel
	}
}

