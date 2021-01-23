import Foundation
import RxSwift

protocol ImageFetchable {
  func fetchImage(
    _ URL: URL?
  ) -> Observable<UIImage>
}
