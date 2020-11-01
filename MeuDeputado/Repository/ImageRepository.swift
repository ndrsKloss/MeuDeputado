import Foundation
import RxSwift

final class ImageRepository: ImageFetchable {
	
	private let cache: ImageCacheType
	private let disposeBag = DisposeBag()
	
	init(cache: ImageCacheType = ImageCache()) {
		self.cache = cache
	}
	
	func fetchImage(_ URL: URL?) -> Observable<UIImage> {
		guard let URL = URL else { return .empty() }
		if let image = cache[URL] { return .just(image) }
		
		return .create { [unowned self] observer -> Disposable in
			let request = URLSession.shared.dataTask(with: URL) { (data: Data?, _: URLResponse?, error: Error?) in
				if let _ = error {
					observer.onCompleted()
					return
				}
				
				if let data = data, let image = UIImage(data: data) {
					self.cache[URL] = image
					observer.onNext(image)
					observer.onCompleted()
				} else {
					observer.onCompleted()
				}
			}
			
			request.resume()
			
			return Disposables.create {
				request.cancel()
			}
		}
	}
}
