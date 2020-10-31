import RxSwift
import RxCocoa

final class MainContentTableViewCellModel: ViewModelType {
	
	typealias MainContent = MainContentViewModel.MainContent
	
	enum Style {
		case deputy, party
	}
	
	struct Constants { }
	
	struct Input { }
	
	struct Output {
		let style: Driver<Style>
		let title: Driver<String>
		let information: Driver<String>
		let image: Driver<Data>
	}
	
	private let content: MainContent
	
	init(content: MainContent) {
		self.content = content
	}
	
	func transform(input: Input) -> Output {
		
		let imageId = Observable.just(content.imageId)
		
		let deputyStyle = imageId
			.unwrap()
			.map { _ in Style.deputy }
		
		let partyStyle = imageId
			.filter { $0 == nil }
			.map { _ in Style.party }
		
		let style = Observable.merge(deputyStyle, partyStyle)
			.asDriverOnErrorJustComplete()
		
		return Output(
			style: style,
			title: .just(content.title),
			information: .just(content.information),
			image: .empty()
		)
	}
}
