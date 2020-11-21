import RxSwift
import RxCocoa

/*
The only purpose of this view model is to show some interaction with the coordinator.
*/

final class FirstViewModel: ViewModelType {

	enum Destination {
        case topSwiftRepos
    }
	
	struct Constants {
		static let buttonTitle = "Começar"
	}
	
	struct Input {
		let startButtonTap: ControlEvent<Void>
	}
	
	struct Output { }
	
	private let navigationPublisher = PublishSubject<Pilot<Destination>>()
	private let disposeBag = DisposeBag()
    
    var navigation: Driver<Pilot<Destination>> {
        navigationPublisher.asDriverOnErrorJustComplete()
    }

	func transform(input: Input) -> Output {
		
		input.startButtonTap
			.map { _ in .init(destination: .topSwiftRepos) }
			.bind(to: navigationPublisher)
			.disposed(by: disposeBag)
		
		return Output()
	}
}
