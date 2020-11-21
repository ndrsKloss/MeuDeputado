import UIKit
import RxSwift

final class ExpensesCoordinator: Coordinatable {
	
    private let contentTocompare = PublishSubject<MainContent>()
    
	let navigationController: UINavigationController
	let content: MainContent
	
	init(
		navigationController: UINavigationController = UINavigationController(),
		content: MainContent
	) {
		self.navigationController = navigationController
		self.content = content
	}
	
	func start() {
        let viewModel = ExpensesViewModel(
            content: content,
            finder: Finder(),
            contentTocompare: contentTocompare)
        
		let viewController = ExpensesViewController(viewModel: viewModel)
        
        viewModel.navigation
            .filter { $0.destination == .toComparation }
            .drive(onNext: { [startTopSwiftRepos] _ in
                startTopSwiftRepos()
            })
            .disposed(by: viewController.disposeBag)
        
		navigationController.pushViewController(
			viewController,
			animated: true
		)
	}
    
    private func startTopSwiftRepos() {
        let viewModel = MainContainerViewModel(finder: Finder())
        let viewController = MainContainerViewController(viewModel: viewModel)
        viewController.apply(style: .presented)
        
        func dismiss(_ content: MainContent) {
            viewController.dismiss(animated: true)
        }
        
        viewModel.navigation
            .filter { $0.destination == .expenses }
            .map { $0.getLuggage() }
            .unwrap()
            .do(afterNext: dismiss)
            .drive(contentTocompare)
            .disposed(by: viewController.disposeBag)
        
        navigationController
            .present(
                viewController,
                animated: true
            )
    }
}
