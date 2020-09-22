import UIKit

extension UIColor {
	var primary: UIColor? {
		UIColor(hex: "DD4C40")
	}
	
	var primaryDark: UIColor? {
		UIColor(hex: "CB382C")
	}
	
	var primaryLight: UIColor? {
		UIColor(hex: "E39B95")
	}
	
	var neutral: UIColor? {
		UIColor(hex: "504567")
	}
	
	var neutralLight: UIColor? {
		UIColor(hex: "9B92AE")
	}
	
	var neutralLighter: UIColor? {
		UIColor(hex: "D3CCE2")
	}
	
	var neutralLightest: UIColor? {
		UIColor(hex: "F2EFF9")
	}
	
}

extension UIColor {
	public convenience init?(hex: String) {
		let r, g, b, a: CGFloat
		
		if hex.count == 8 {
			let scanner = Scanner(string: hex)
			var hexNumber: UInt64 = 0
			
			if scanner.scanHexInt64(&hexNumber) {
				r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
				g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
				b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
				a = CGFloat(hexNumber & 0x000000ff) / 255
				
				self.init(red: r, green: g, blue: b, alpha: a)
				return
			}
		}
		return nil
	}
}
