import UIKit

protocol LoadPresentable {
  func configureLoaderView() -> LoaderView
}

protocol ErrorPresentable {
  func configureErrorView() -> ErrorView
}

protocol LoaderAndErrorPresentable: LoadPresentable, ErrorPresentable {}
