import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
	var guide: UILayoutGuide {
		view.safeAreaLayoutGuide
	}
	
	var margins: UILayoutGuide {
		view.layoutMarginsGuide
	}
}

extension Reactive where Base: UIViewController {
	var viewWillAppear: ControlEvent<Bool> {
		let source = self.methodInvoked(#selector(Base.viewWillAppear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
}

extension LoaderAndErrorPresentable where Self: UIViewController {
	func configureLoaderView() -> LoaderView {
		let loaderView = LoaderView()
		
		view.addSubviewWithAutolayout(loaderView)
		
		NSLayoutConstraint.activate([
			loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			loaderView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			loaderView.leadingAnchor.constraint(greaterThanOrEqualTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(greaterThanOrEqualTo: loaderView.trailingAnchor),
			guide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: loaderView.bottomAnchor, multiplier: 1.0)
		])
		
		return loaderView
	}
}

extension LoaderAndErrorPresentable where Self: UIViewController {
	func configureErrorView() -> ErrorView {
		let errorView = ErrorView()

		view.addSubviewWithAutolayout(errorView)
		
		NSLayoutConstraint.activate([
			errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			errorView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			errorView.leadingAnchor.constraint(greaterThanOrEqualTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(greaterThanOrEqualTo: errorView.trailingAnchor),
			guide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: errorView.bottomAnchor, multiplier: 1.0)
		])
		
		return errorView
	}
}
