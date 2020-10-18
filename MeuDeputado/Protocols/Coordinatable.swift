import UIKit

protocol Coordinatable {
	var navigationController: UINavigationController { get }
	
	func start()
}
