import UIKit

final class FirstViewController: UIViewController {
	
	typealias Constants = FirstViewModel.Constants
	typealias Input = FirstViewModel.Input
	
	private let viewModel: FirstViewModel
	
	private let button: UIButton = {
		$0.setTitle(Constants.buttonTitle, for: .normal)
		return $0
	}(UIButton())
	
	init(
		viewModel: FirstViewModel = FirstViewModel()
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
		configureButton()
		transform()
	}
	
	private func transform() {
		let input = Input(
			startButtonTap: button.rx.tap
		)
		
		_ = viewModel.transform(input: input)
	}
	
	private func configureSelf() {
		view.backgroundColor = .neutralLighter
	}
	
	private func configureButton() {
		view.addSubview(button)

		NSLayoutConstraint.activate([
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: Spacing.medium),
			button.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Spacing.medium),
			view.trailingAnchor.constraint(greaterThanOrEqualTo: button.trailingAnchor, constant: Spacing.medium),
			view.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor, constant: Spacing.medium)
		])
	}
}
