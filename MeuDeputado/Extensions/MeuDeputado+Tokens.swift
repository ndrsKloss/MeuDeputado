import UIKit
import CoreGraphics

struct Thickness {
    /// Value of 0.0.
    static let none: CGFloat = 0.0
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
	/// Value of the lowest value between frame's width and height divided by 2.
	static func circular(_ frame: CGRect) -> CGFloat {
		min(frame.width, frame.height) / 2
	}
	/// Value of the lowest value between width and height divided by 2.
	static func circular(width: CGFloat, height: CGFloat) -> CGFloat {
		min(width, height) / 2
	}
}

struct Shadow {
	struct Large {
		static let shadowOpacity: Float = 0.25
		static let shadowOffset = CGSize(width: 0, height: 4)
		static let shadowRadius: CGFloat = 16.0
	}
}

struct FontSize {
	/// Value of 34.0.
	static let xxlarge: CGFloat = 34.0
	/// Value of 28.0.
	static let xlarge: CGFloat = 28.0
	/// Value of 22.0.
	static let large: CGFloat = 22.0
	/// Value of 18.0.
	static let medium: CGFloat = 18.0
	/// Value of 16.0.
	static let base: CGFloat = 16.0
	/// Value of 14.0.
	static let small: CGFloat = 14.0
	/// Value of 10.0.
	static let xsmall: CGFloat = 10.0
}

extension UIFont {
	static var largeTitle: UIFont {
        UIFont.preferredFont(for: .largeTitle, weight: .bold)
	}
	
	static var title1: UIFont {
		UIFont.preferredFont(for: .title1, weight: .bold)
	}
	
	static var title2: UIFont {
		UIFont.preferredFont(for: .title2, weight: .bold)
	}
	
	static var title3: UIFont {
        UIFont.preferredFont(for: .title3, weight: .heavy)
	}
	
	static var subhead: UIFont {
		UIFont.preferredFont(for: .subheadline, weight: .bold)
	}
	
	static var headline: UIFont {
		UIFont.preferredFont(for: .headline, weight: .medium)
	}
	
	static var body: UIFont {
		UIFont.preferredFont(for: .body, weight: .light)
	}
	
	static var callout: UIFont {
		UIFont.preferredFont(for: .callout, weight: .light)
	}
	
	static var callout2: UIFont {
		UIFont.preferredFont(for: .callout, weight: .bold)
	}
}

extension UIColor {
	static var primary: UIColor {
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
