import UIKit

extension UILabel: Styleable {
	public struct UILabelStyle {
		let font: UIFont
	}
	
	public func apply(style: UILabelStyle) {
		self.font = style.font
	}
}

/*
extension UIButton: Styleable {
	public func apply(style: UIButtonStyle) {
		titleLabel?.numberOfLines = 0
		titleLabel?.font = style.font
		setTitleColor(style.color, for: .normal)
	}
	
	public struct UIButtonStyle {
		let font: UIFont
		let color: UIColor
		
		public static let style1 = UIButtonStyle(
			font: UIFont.preferredFont(forTextStyle: .title1),
			color: .lightest
		)
		
		public static let style2 = UIButtonStyle(
			font: UIFont.preferredFont(forTextStyle: .title1),
			color: .neutralLight
		)
	}
}

*/
