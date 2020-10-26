import UIKit

extension UIView {
	func addSubview(_ view: UIView, withConstraints: Bool) {
		view.translatesAutoresizingMaskIntoConstraints = !withConstraints
		addSubview(view)
	}
}
