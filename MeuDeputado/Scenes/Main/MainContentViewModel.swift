final class MainContentViewModel: ViewModelType {
	
	struct Constants { }
	
	struct Input { }
	
	struct Output { }
	
	private let content: [MainContent]
	
	init(content: [MainContent]) {
		self.content = content
	}
	
	func transform(input: Input) -> Output {
		Output()
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
