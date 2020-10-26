import UIKit

final class MainCoordinator: Coordinatable {
	
	let navigationController: UINavigationController
	
	init(
		navigationController: UINavigationController = UINavigationController()
	) {
		self.navigationController = navigationController
		configureNavigationController()
	}
	
	private func configureNavigationController() {
		navigationController.navigationBar.prefersLargeTitles = true
	}
	
	func start() {
		navigationController.pushViewController(
			TwoOptionsContainerViewController(),
			animated: true
		)
	}
}
