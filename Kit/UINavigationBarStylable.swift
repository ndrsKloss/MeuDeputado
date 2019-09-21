import UIKit

struct NavigationBarStyle {
    let prefersLargeTitles: Bool

    static var `default`: NavigationBarStyle {
        return NavigationBarStyle(prefersLargeTitles: true)
    }
}

extension UINavigationBar: Styleable {
    func apply(style: NavigationBarStyle) {
        self.prefersLargeTitles = style.prefersLargeTitles
    }
    
    
}
