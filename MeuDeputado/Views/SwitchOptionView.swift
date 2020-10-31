import UIKit
import RxSwift
import RxCocoa

final class SwitchOptionView: UIView {
	
	typealias Constants = SwitchOptionViewModel.Constants
	typealias Input = SwitchOptionViewModel.Input
	
	private let viewModel: SwitchOptionViewModel
	
	private let disposeBag = DisposeBag()
	
	private let stackView: UIStackView = {
		$0.axis = .horizontal
		$0.distribution = .fillEqually
		return $0
	}(UIStackView())
	
	private let selectView: UIView = {
		$0.layer.shadowOpacity = Shadow.Large.shadowOpacity
		$0.layer.shadowOffset = Shadow.Large.shadowOffset
		$0.layer.shadowRadius = Shadow.Large.shadowRadius
		$0.layer.cornerRadius = 12.0
		$0.backgroundColor = .primaryDark
		return $0
	}(UIView())

	fileprivate let leftButton = SwitchOptionButton()
	
	fileprivate let rightButton = SwitchOptionButton()
	
	private lazy var leadingSelectViewConstraint = selectView.leadingAnchor.constraint(
		equalTo: leadingAnchor,
		constant: 4.0
	)
	
	private lazy var trailingSelectViewConstraint: NSLayoutConstraint = {
		let constraint = trailingAnchor.constraint(
			equalTo: selectView.trailingAnchor,
			constant: 4.0
		)
		constraint.priority = .defaultLow
		return constraint
	}()
	
	init(
		viewModel: SwitchOptionViewModel = SwitchOptionViewModel()
	) {
		self.viewModel = viewModel
		super.init(frame: .zero)

		configureSelf()
		configureSelectView()
		configureStackView()
		configureLeftButton()
		configureRightButton()
		configureBinds()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	private func configureSelf() {
		layer.cornerRadius = 16.0
		layer.borderWidth = Thickness.medium
		layer.borderColor = UIColor.neutralBase.cgColor
	}
	
	private func configureStackView() {
		addSubviewWithAutolayout(stackView)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
			bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
		])
	}
	
	private func configureSelectView() {
		addSubviewWithAutolayout(selectView)
		
		NSLayoutConstraint.activate([
			selectView.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
			leadingSelectViewConstraint,
			trailingSelectViewConstraint,
			bottomAnchor.constraint(equalTo: selectView.bottomAnchor, constant: 4.0),
			selectView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
		])
	}
	
	private func configureLeftButton() {
		leftButton.setTitle(Constants.leftButtonTitle, for: .normal)
		stackView.addArrangedSubview(leftButton)
	}
	
	private func configureRightButton() {
		rightButton.setTitle(Constants.rightButtonTitle, for: .normal)
		stackView.addArrangedSubview(rightButton)
	}
	
	private func configureBinds() {
		let input = Input(
			leftButtonTap: leftButton.rx.tap,
			rightButtonTap: rightButton.rx.tap
		)
		
		let output = viewModel.transform(input: input)
		
		output.state
			.filter { $0 == .left }
			.drive(onNext: { [weak self] _ in
				self?.selectLeft()
			})
			.disposed(by: disposeBag)
		
		output.state
			.filter { $0 == .right }
			.drive(onNext: { [weak self] _ in
				self?.selectRight()
			})
			.disposed(by: disposeBag)
	}
	
	private func selectLeft() {
		leadingSelectViewConstraint.isActive = true
		leftButton.apply(style: .selected)
		rightButton.apply(style: .unselected)
	}
	
	private func selectRight() {
		leadingSelectViewConstraint.isActive = false
		rightButton.apply(style: .selected)
		leftButton.apply(style: .unselected)
	}
}

private final class SwitchOptionButton: UIButton { }

extension SwitchOptionButton: Styleable {
	struct UIButtonStyle {
		let font: UIFont
		let color: UIColor
		
		static let selected = UIButtonStyle(
			font: UIFont.preferredFont(forTextStyle: .headline),
			color: .neutralLighter
		)
		
		static let unselected = UIButtonStyle(
			font: UIFont.preferredFont(forTextStyle: .headline),
			color: .neutralDark
		)
	}
	
	func apply(style: UIButtonStyle) {
		contentEdgeInsets = UIEdgeInsets(top: Spacing.small, left: 0.0, bottom: Spacing.small, right: 0.0)
		titleLabel?.lineBreakMode = .byCharWrapping
		titleLabel?.numberOfLines = 0
		titleLabel?.font = style.font
		titleLabel?.adjustsFontForContentSizeCategory = true
		setTitleColor(style.color, for: .normal)
	}
}

extension Reactive where Base: SwitchOptionView {
	var leftTap: ControlEvent<Void> {
		base.leftButton.rx.tap
	}
	
	var rightTap: ControlEvent<Void> {
		base.rightButton.rx.tap
	}
}
