import Foundation
import UIKit

// https://medium.com/flawless-app-stories/reusable-image-cache-in-swift-9b90eb338e8d
protocol ImageCacheType: class {
    
    func image(for url: URL) -> UIImage?
    
    func insertImage(_ image: UIImage?, for url: URL)
    
    func removeImage(for url: URL)
    
    func removeAllImages()

    subscript(_ url: URL) -> UIImage? { get set }
}
