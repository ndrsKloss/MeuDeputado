import Foundation
import UIKit

final class ImageCache {

	private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
		let cache = NSCache<AnyObject, AnyObject>()
		cache.countLimit = config.countLimit
		return cache
	}()
	
	private let lock = NSLock()
	private let config: Config
	
	struct Config {
		let countLimit: Int
		let memoryLimit: Int
		
		// 100 MB
		static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100)
	}
	
	init(config: Config = Config.defaultConfig) {
		self.config = config
	}
}

extension ImageCache: ImageCacheType {
	
	func removeAllImages() {
		lock.lock(); defer { lock.unlock() }
		imageCache.removeAllObjects()
	}
	
	func insertImage(_ image: UIImage?, for url: URL) {
		guard let image = image else { return removeImage(for: url) }
		
		lock.lock(); defer { lock.unlock() }
		imageCache.setObject(image, forKey: url as AnyObject)
	}
	
	func removeImage(for url: URL) {
		lock.lock(); defer { lock.unlock() }
		imageCache.removeObject(forKey: url as AnyObject)
	}
	
	func image(for url: URL) -> UIImage? {
		lock.lock(); defer { lock.unlock() }
		if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
			return image
		}
		return nil
	}
}

extension ImageCache {
	subscript(_ key: URL) -> UIImage? {
		get {
			return image(for: key)
		}
		set {
			return insertImage(newValue, for: key)
		}
	}
}
