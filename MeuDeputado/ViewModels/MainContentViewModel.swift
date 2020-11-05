import RxSwift
import RxCocoa

final class MainContentViewModel: ViewModelType {
	
	enum Destination {
        case expenses
    }
	
	struct Constants {
		static let mainContentCellIdentifier = String(describing: MainContenTableViewCell.self)
	}
	
	struct Input {
		let itemSelected: ControlEvent<IndexPath>
	}
	
	struct Output {
		let dataSource: Driver<[MainContentTableViewCellModel]>
	}

	private let disposeBag = DisposeBag()
	private let navigationPublisher = PublishSubject<Pilot<Destination>>()
	
	private let content: [MainContent]
	
	var navigation: Driver<Pilot<Destination>> {
		navigationPublisher.asDriverOnErrorJustComplete()
    }
	
	init(content: [MainContent]) {
		self.content = content
	}
	
	private func getContent(
		index: IndexPath
	) -> MainContent {
		content[index.row]
	}

	private func prepareForDeparture(
		_ content: MainContent
	) -> Pilot<Destination>{
		.init(destination: .expenses, luggage: content)
	}
	
	func transform(input: Input) -> Output {
		
		input.itemSelected
			.map(getContent)
			.map(prepareForDeparture)
			.bind(to: navigationPublisher)
			.disposed(by: disposeBag)
		
		let dataSource = Driver.just(content)
			.map { $0.map { MainContentTableViewCellModel(content: $0) } }
		
		return Output(dataSource: dataSource)
	}
}
