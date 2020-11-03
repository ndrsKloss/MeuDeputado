import UIKit

final class ExpensesViewController: UIViewController {
	
	private let viewModel: ExpensesViewModel
	
	init(
		viewModel: ExpensesViewModel = ExpensesViewModel()
	) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(
		coder aDecoder: NSCoder
	) {
		return nil
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureSelf()
	}

	private func configureSelf() {
		view.backgroundColor = .neutralLighter
	}
}
