import RxCocoa

final class MainContentViewModel: ViewModelType {
	
	struct Constants {
		static let mainContentCellIdentifier = String(describing: MainContenTableViewCell.self)
	}
	
	struct Input { }
	
	struct Output {
		let dataSource: Driver<[MainContentTableViewCellModel]>
	}
	
	private let content: [MainContent]
	
	init(content: [MainContent]) {
		self.content = content
	}
		
	func transform(input: Input) -> Output {
		
		let dataSource = Driver.just(content)
			.map { $0.map(MainContentTableViewCellModel.init) }
		
		return Output(dataSource: dataSource)
	}
}

extension MainContentViewModel {
	struct MainContent {
		let title: String
		let information: String
		let imageId: String?
		
		init(
			title: String,
			information: String,
			imageId: String? = nil
		) {
			self.title = title
			self.information = information
			self.imageId = imageId
		}
	}
}
