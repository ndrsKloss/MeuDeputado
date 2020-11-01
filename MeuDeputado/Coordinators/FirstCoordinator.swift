import UIKit
import RxSwift
import RxCocoa

final class FirstCoordinator: Coordinatable {
	
	let navigationController: UINavigationController
	
	private let disposeBag = DisposeBag()
	
	init(
		navigationController: UINavigationController = UINavigationController()
	) {
		self.navigationController = navigationController
	}
	
	func start() {
		let viewModel = FirstViewModel()
		let viewController = FirstViewController(viewModel: viewModel)
		
		navigationController.pushViewController(
			viewController,
			animated: true
		)
		
		viewModel.navigation
			.filter { $0.destination == .topSwiftRepos }
			.drive(onNext: { [startTopSwiftRepos] _ in
				startTopSwiftRepos()
			})
			.disposed(by: disposeBag)
	}
	
	func startTopSwiftRepos() {
		let coordinator = MainCoordinator(navigationController: navigationController)
		coordinator.start()
	}
}
