import UIKit

final class LoaderView: UIView {
	
	private let activitiIndicatorView: UIActivityIndicatorView = {
		$0.hidesWhenStopped = true
		return $0
	}(UIActivityIndicatorView(style: .gray))
	
	init() {
		super.init(frame: .zero)
		configureSelf()
		configureActivitiIndicatorView()
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
	
	private func configureActivitiIndicatorView() {
		addSubview(activitiIndicatorView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			activitiIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.small),
			activitiIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.small),
			trailingAnchor.constraint(equalTo: activitiIndicatorView.trailingAnchor, constant: Spacing.small),
			bottomAnchor.constraint(equalTo: activitiIndicatorView.bottomAnchor, constant: Spacing.small)
		])
	}
	
	func startAnimating() {
		activitiIndicatorView.startAnimating()
	}
	
	func stopAnimating() {
		activitiIndicatorView.stopAnimating()
	}
}
