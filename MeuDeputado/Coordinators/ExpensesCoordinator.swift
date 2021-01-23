import RxSwift
import UIKit

final class ExpensesCoordinator: Coordinatable {

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
    let viewModel = ExpensesViewModel(content: content, finder: Finder())
    let viewController = ExpensesViewController(viewModel: viewModel)

    navigationController.pushViewController(
      viewController,
      animated: true
    )
  }
}
