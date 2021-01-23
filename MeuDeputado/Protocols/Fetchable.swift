import Parse
import RxSwift

protocol Fetchable {
  func find<T: PFObject>(query: PFQuery<T>?) -> Single<[T]>
}
