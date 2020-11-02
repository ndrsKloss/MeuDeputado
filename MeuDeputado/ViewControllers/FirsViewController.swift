import UIKit

final class FirstViewController: UIViewController {
	
	typealias Constants = FirstViewModel.Constants
	typealias Input = FirstViewModel.Input
	
	private let viewModel: FirstViewModel
	
	private let button: FirstViewButton = {
		$0.setTitle(Constants.buttonTitle, for: .normal)
		$0.apply(style: .normal)
		return $0
	}(FirstViewButton())
	
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
		view.addSubviewWithAutolayout(button)

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


private final class FirstViewButton: UIButton { }


extension FirstViewButton: Styleable {
	struct UIButtonStyle {
		static let normal = UIButtonStyle()
	}
	
	func apply(style: UIButtonStyle) {
		contentEdgeInsets = UIEdgeInsets(top: Spacing.small, left: Spacing.small, bottom: Spacing.small, right: Spacing.small)
		layer.borderColor = UIColor.neutralDark.cgColor
		layer.borderWidth = Thickness.medium
		layer.cornerRadius = Radius.small
		titleLabel?.lineBreakMode = .byCharWrapping
		titleLabel?.numberOfLines = 0
		titleLabel?.font = .headline
		titleLabel?.adjustsFontForContentSizeCategory = true
		setTitleColor(.neutralDark, for: .normal)
		setTitleColor(.neutralBase, for: .highlighted)
	}
}

