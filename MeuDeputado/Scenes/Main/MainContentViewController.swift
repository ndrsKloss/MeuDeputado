import UIKit
import RxSwift

final class MainContentViewController: UIViewController {
	
	typealias Input = MainContentViewModel.Input
	
	private let viewModel: MainContentViewModel
	
	init(
		viewModel: MainContentViewModel
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
	}
	
	private func configureSelf() {
		view.backgroundColor = .neutralLighter
	}
	
}
