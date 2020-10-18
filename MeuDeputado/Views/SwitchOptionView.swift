import UIKit

final class SwitchOptionView: UIView {
	
	private let stackView: UIStackView = {
		$0.axis = .horizontal
		$0.distribution = .equalCentering
		$0.alignment = .center
		return $0
	}(UIStackView())
	
	private let selectView: UIView = {
		$0.layer.cornerRadius = .cornerRadious1
		$0.layer.borderWidth = .borderWidth1
		$0.backgroundColor = .primary
		return $0
	}(UIView())
	
	let leftButton: UIButton = {
		$0.apply(style: .style1)
		return $0
	}(UIButton())
	
	let rightButton: UIButton = {
		$0.apply(style: .style2)
		return $0
	}(UIButton())
	
	init() {
		super.init(frame: .zero)
		
		configureSelf()
		setupSelectView()
		configureStackView()
		configureLeftButton()
		configureRightButton()
	}
	
	@available(*, unavailable)
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	private func configureSelf() {
		layer.cornerRadius = .cornerRadious1
		layer.borderWidth = .borderWidth1
		layer.borderColor = UIColor.neutralLighter.cgColor
	}
	
	private func configureStackView() {
		addSubview(stackView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
			bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
		])
	}
	
	private func setupSelectView() {
		addSubview(selectView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			selectView.topAnchor.constraint(equalTo: topAnchor, constant: 1.0),
			selectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1.0),
			bottomAnchor.constraint(equalTo: selectView.bottomAnchor, constant: 1.0),
			selectView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
		])
		
		layoutIfNeeded()
	}
	
	private func configureLeftButton() {
		leftButton.setTitle("Deputados", for: .normal)
		stackView.addArrangedSubview(leftButton)
	}
	
	private func configureRightButton() {
		rightButton.setTitle("Partidos", for: .normal)
		stackView.addArrangedSubview(rightButton)
	}
}
