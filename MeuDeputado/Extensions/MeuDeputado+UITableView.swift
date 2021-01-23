import UIKit

extension UITableView {
  func register(_ classes: AnyClass...) {
    classes.forEach { register($0, forCellReuseIdentifier: String(describing: $0)) }
  }
}
