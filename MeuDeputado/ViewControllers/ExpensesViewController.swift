import UIKit
import Parse

final class ExpensesViewController: UIViewController {
	
	typealias Input = ExpensesViewModel.Input
	
	private let viewModel: ExpensesViewModel
	
	init(
		viewModel: ExpensesViewModel
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
		transform()
	}

	private func configureSelf() {
		view.backgroundColor = .neutralLighter
	}
	
	private func transform() {
		let output = viewModel.transform(input: Input())
	}
}
