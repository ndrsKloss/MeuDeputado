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
	var loaderView: LoaderView {
		LoaderView()
	}

	func configureLoaderView() {
		self.view.addSubview(loaderView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			loaderView.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			loaderView.leadingAnchor.constraint(lessThanOrEqualTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(lessThanOrEqualTo: loaderView.trailingAnchor),
			guide.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: loaderView.bottomAnchor, multiplier: 1.0)
		])
	}
}

extension LoaderAndErrorPresentable where Self: UIViewController {
	var errorView: ErrorView {
		ErrorView()
	}
	
	func configureErrorView() {
		view.addSubview(errorView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			errorView.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			errorView.leadingAnchor.constraint(lessThanOrEqualTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(lessThanOrEqualTo: errorView.trailingAnchor),
			guide.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: errorView.bottomAnchor, multiplier: 1.0)
		])
	}
}
