import UIKit
import RxSwift

final class MainCoordinator: Coordinatable {
	
	private let disposeBag = DisposeBag()
	
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
		let viewModel = MainContainerViewModel(finder: Finder())
		let viewController = MainContainerViewController(viewModel: viewModel)
		
		viewModel.navigation
			.filter { $0.destination == .expenses }
			.map { $0.getLuggage() }
			.unwrap()
			.drive(onNext: startExpenses)
			.disposed(by: viewController.disposeBag)

		navigationController.pushViewController(
			viewController,
			animated: true
		)
	}
	
	func startExpenses(content: MainContent) {
		let coordinator = ExpensesCoordinator(
			navigationController: navigationController,
			content: content
		)
		coordinator.start()
	}
}
