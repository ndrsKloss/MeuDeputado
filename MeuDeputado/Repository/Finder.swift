import Parse
import RxSwift
import RxCocoa

class Finder: Fetchable {
	func find<T>(query: PFQuery<T>?) -> Single<[T]> where T : PFObject {
		// TODO: Return some reasonable error.
		guard let query = query else { return .error(NSError()) }
		
		return Single<[T]>.create { single in
			do {
				let objects = try query.findObjects()
				single(.success(objects))
			} catch let error {
				single(.error(error))
			}
			return Disposables.create { query.cancel() }
		}
		.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
	}
}
