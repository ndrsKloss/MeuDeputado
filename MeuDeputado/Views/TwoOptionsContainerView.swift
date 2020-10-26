import UIKit

final class TwoOptionsContainerView: UIView {
	
	let switchOptionView = SwitchOptionView()
	
	init() {
		super.init(frame: .zero)
		configureSelf()
		configureSwitchOptionView()
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
		backgroundColor = .neutralLighter
	}
	
	private func configureSwitchOptionView() {
		addSubview(switchOptionView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			switchOptionView.centerXAnchor.constraint(equalTo: centerXAnchor),
			switchOptionView.topAnchor.constraint(equalTo: topAnchor),
            switchOptionView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor),
			trailingAnchor.constraint(lessThanOrEqualTo: switchOptionView.trailingAnchor)
		])
	}
}