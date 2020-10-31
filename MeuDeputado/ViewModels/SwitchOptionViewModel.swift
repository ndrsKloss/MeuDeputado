import RxSwift
import RxCocoa

final class SwitchOptionViewModel: ViewModelType {
	struct Constants {
		static let leftButtonTitle = NSLocalizedString("Deputy", comment: "")
		static let rightButtonTitle = NSLocalizedString("Party", comment: "")
	}
	
	enum State {
		case left, right
	}
	
	private var initialState: State
	
	struct Input {
		let leftButtonTap: ControlEvent<Void>
		let rightButtonTap: ControlEvent<Void>
	}
	
	struct Output {
		let state: Driver<State>
	}
	
	init(state: State = .left) {
		initialState = state
	}
	
	func transform(input: Input) -> Output {
		
		let initialState = Driver.just(self.initialState)
		
		let leftState = input.leftButtonTap
			.map { _ in State.left }
			.asDriver(onErrorDriveWith: .empty())
		
		let rightState = input.rightButtonTap
			.map { _ in State.right }
			.asDriver(onErrorDriveWith: .empty())
		
		let state = Driver.merge(initialState, leftState, rightState)
			.distinctUntilChanged()
		
		return Output(state: state)
	}
}
