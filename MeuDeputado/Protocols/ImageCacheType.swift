import Foundation
import UIKit

protocol ImageCacheType: class {

  func image(for url: URL) -> UIImage?

  func insertImage(_ image: UIImage?, for url: URL)

  func removeImage(for url: URL)

  func removeAllImages()

  subscript(_ url: URL) -> UIImage? { get set }
}
