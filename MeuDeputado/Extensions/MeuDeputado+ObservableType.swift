import RxCocoa
// @sergdort
import RxSwift

extension ObservableType {
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    asDriver { error in
      Driver.empty()
    }
  }
}
