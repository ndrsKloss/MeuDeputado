// @sergdort
import RxSwift
import RxCocoa

extension ObservableType {
	func asDriverOnErrorJustComplete() -> Driver<Element> {
		asDriver { error in
			Driver.empty()
		}
	}
}
