import UIKit
import CoreGraphics

struct Thickness {
	/// Value of 4.0.
	static let larger: CGFloat = 4.0
	/// Value of 2.0.
	static let medium: CGFloat = 2.0
	/// Value of 1.0.
	static let small: CGFloat = 1.0
}

struct Spacing {
	/// Value of 4.0.
	static let xxsmall: CGFloat = 4.0
	/// Value of 8.0.
	static let xsmall: CGFloat = 8.0
	/// Value of 12.0.
	static let small: CGFloat = 12.0
	/// Value of 16.0.
	static let medium: CGFloat = 16.0
	/// Value of 24.0.
	static let large: CGFloat = 24.0
	/// Value of 32.0.
	static let xlarge: CGFloat = 32.0
}

struct Radius {
	/// Value of 0.0.
	static let none: CGFloat = 0.0
	/// Value of 8.0.
	static let small: CGFloat = 8.0
	/// Value of 16.0.
	static let medium: CGFloat = 16.0
	/// Value of the lowest value between width and height divided by 2.
	static func circular(_ frame: CGRect) -> CGFloat {
		min(frame.width, frame.height) / 2
	}
}

struct Shadow {
	struct Large {
		static let shadowOpacity: Float = 0.25
		static let shadowOffset = CGSize(width: 0, height: 4)
		static let shadowRadius: CGFloat = 16.0
	}
}

extension UIColor {
	static var primary: UIColor? {
		UIColor(hex: 0xDD4C40)
	}
	
	static var primaryDark: UIColor {
		UIColor(hex: 0xCB382C)
	}
	
	static var primaryLight: UIColor {
		UIColor(hex: 0xE39B95)
	}
	
	static var neutralDarker: UIColor {
		UIColor(hex: 0x504567)
	}
	
	static var neutralDark: UIColor {
		UIColor(hex: 0x9B92AE)
	}
	
	static var neutralBase: UIColor {
		UIColor(hex: 0xD3CCE2)
	}
	
	static var neutralLight: UIColor {
		UIColor(hex: 0xF2EFF9)
	}
	
	static var neutralLighter: UIColor {
		UIColor(hex: 0xFFFFFF)
	}
}

private extension UIColor {
	convenience init(hex: Int) {
		let red = (hex >> 16) & 0xff
		let green = (hex >> 8) & 0xff
		let blue = hex & 0xff
	
		self.init(
			red: CGFloat(red) / 255.0,
			green: CGFloat(green) / 255.0,
			blue: CGFloat(blue) / 255.0,
			alpha: 1
		)
	}
}
