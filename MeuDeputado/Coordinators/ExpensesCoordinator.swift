import UIKit
import RxSwift

final class ExpensesCoordinator: Coordinatable {
	
	let navigationController: UINavigationController
	let mainContent: MainContent
	
	init(
		navigationController: UINavigationController = UINavigationController(),
		content: MainContent
	) {
		self.navigationController = navigationController
		mainContent = content
	}
	
	func start() { 
	}
}
