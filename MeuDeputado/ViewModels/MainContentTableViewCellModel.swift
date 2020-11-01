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
		let image: Driver<UIImage>
	}
	
	private let content: MainContent
	private let imageFetcher: ImageFetchable
	private let operation: OperationScheduable
	
	init(
		content: MainContent,
		imageFetcher: ImageFetchable = ImageRepository(),
		operation: OperationScheduable = RepositoryOperation()
	) {
		self.imageFetcher = imageFetcher
		self.content = content
		self.operation = operation
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
		
		let image = imageId
			.unwrap()
			.map { Endpoint.image(id: $0).makeURL() }
			.unwrap()
			.flatMapLatest(imageFetcher.fetchImage)
			.subscribeOn(operation.scheduler)
			.asDriverOnErrorJustComplete()
		
		return Output(
			style: style,
			title: .just(content.title),
			information: .just(content.information),
			image: image
		)
	}
}
