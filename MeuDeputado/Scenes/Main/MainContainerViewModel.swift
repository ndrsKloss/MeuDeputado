import RxCocoa
import RxSwift
import RxSwiftExt

final class MainContainerViewModel: ViewModelType {
	
	struct Constants {
		static let appName = NSLocalizedString("App-Name", comment: "")
	}
	
	struct Input {
		let viewWillAppear: ControlEvent<Bool>
		let leftTap: ControlEvent<Void>
		let rightTap: ControlEvent<Void>
	}
	
	struct Output {
		let rawContent: Driver<[MainContentViewModel]>
	}
	
	private let finder: Fetchable

	private let disposeBag = DisposeBag()
	
	init(finder: Fetchable) {
		self.finder = finder
	}
	
	func transform(input: Input) -> Output {
		
		let rawContent = input.viewWillAppear
			.take(1)
			.map { _ in () }
			.flatMapLatest(allDeputiesInMandate)
			.map(self.rawContent)
			.asDriverOnErrorJustComplete()
		
		return Output(rawContent: rawContent)
	}
	
	private func allDeputiesInMandate() -> Observable<[Deputy]> {
		finder.find(query: getAllDeputiesInMandateQuery)
			.asObservable()
			.map { $0 as? [Deputy] }
			.unwrap()
	}
	
	private func rawContent(
		_ deputies: [Deputy]
	) -> [MainContentViewModel] {
		[MainContentViewModel(deputies: deputies, preparer: MainContentDeputies()),
		 MainContentViewModel(deputies: deputies, preparer: MainContentParties())]
	}
}

