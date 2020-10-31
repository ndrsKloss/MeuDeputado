import RxSwift
import RxCocoa

final class MainContentTableViewCellModel: ViewModelType {
	
	typealias MainContent = MainContentViewModel.MainContent
	
	struct Constants { }
	
	struct Input { }
	
	struct Output { }
	
	private let content: MainContent
	
	init(content: MainContent) {
		self.content = content
	}
	
	func transform(input: Input) -> Output {
		return Output()
	}
}


