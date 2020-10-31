import UIKit
import RxSwift
import RxCocoa

final class ErrorView: UIView {
	
	fileprivate let button = UIButton()
	
	init() {
		super.init(frame: .zero)
		configureSelf()
		configureErrorView()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	private func configureSelf() {
		backgroundColor = .neutralLighter
		layer.shadowOpacity = Shadow.Large.shadowOpacity
		layer.shadowOffset = Shadow.Large.shadowOffset
		layer.shadowRadius = Shadow.Large.shadowRadius
		layer.cornerRadius = Radius.medium
	}
	
	private func configureErrorView() {
		addSubviewWithAutolayout(button)
		
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.small),
			button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.small),
			trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: Spacing.small),
			bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: Spacing.small)
		])
	}
}

extension Reactive where Base: ErrorView {
	var tap: ControlEvent<Void> {
		base.button.rx.tap
	}
}
