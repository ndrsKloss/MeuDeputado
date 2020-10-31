import UIKit

protocol LoadPresentable {
	var loaderView: LoaderView { get }
	
	func configureLoaderView()
}

protocol ErrorPresentable {
	var errorView: ErrorView { get }
	
	func configureErrorView()
}

protocol LoaderAndErrorPresentable: LoadPresentable, ErrorPresentable { }
