import UIKit

extension UIView {
	func addSubviewWithAutolayout(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
	}
}
