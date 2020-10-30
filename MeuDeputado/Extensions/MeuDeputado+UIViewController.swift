import UIKit
import RxCocoa
import RxSwift

extension UIViewController {
	private var guide: UILayoutGuide {
		view.safeAreaLayoutGuide
	}
	
	private var margins: UILayoutGuide {
		view.layoutMarginsGuide
	}
}

public extension Reactive where Base: UIViewController {
	var viewWillAppear: ControlEvent<Bool> {
		let source = self.methodInvoked(#selector(Base.viewWillAppear))
			.map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
}
