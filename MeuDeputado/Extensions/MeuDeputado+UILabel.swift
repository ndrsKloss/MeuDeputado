import UIKit

extension UILabel: Styleable {
	public struct UILabelStyle {
		let font: UIFont
	}
	
	public func apply(style: UILabelStyle) {
		self.font = style.font
	}
}
