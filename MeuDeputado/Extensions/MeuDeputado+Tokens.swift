import CoreGraphics

struct Thickness {
	/// Value of 4.0.
	static let larger: CGFloat = 4.0
	/// Value of 2.0.
	static let medium: CGFloat = 2.0
	/// Value of 1.0.
	static let small: CGFloat = 1.0
}

struct Shadow {
	struct Large {
		static let shadowOpacity: Float = 0.25
		static let shadowOffset = CGSize(width: 0, height: 4)
		static let shadowRadius: CGFloat = 16.0
	}
}
