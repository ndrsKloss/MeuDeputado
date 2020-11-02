import RxSwift
import RxCocoa

final class MainContentViewModel: ViewModelType {
	
	enum Destination {
        case analysis
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
		.init(destination: .analysis, luggage: content)
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

extension MainContentViewModel {
	struct MainContent {
		let id: String?
		let title: String
		let information: String
		let imageId: String?
		
		init(
			id: String?,
			title: String,
			information: String,
			imageId: String? = nil
		) {
			self.id = id
			self.title = title
			self.information = information
			self.imageId = imageId
		}
	}
}
