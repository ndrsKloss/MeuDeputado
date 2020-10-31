import UIKit

final class LoaderView: UIView {
	
	private let activitiIndicatorView: UIActivityIndicatorView = {
		if #available(iOS 13, *) {
			$0.style = .large
		} else {
			$0.style = .gray
		}
		$0.hidesWhenStopped = true
		return $0
	}(UIActivityIndicatorView())
	
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
		addSubviewWithAutolayout(activitiIndicatorView)
		
		NSLayoutConstraint.activate([
			activitiIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.large),
			activitiIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.large),
			trailingAnchor.constraint(equalTo: activitiIndicatorView.trailingAnchor, constant: Spacing.large),
			bottomAnchor.constraint(equalTo: activitiIndicatorView.bottomAnchor, constant: Spacing.large)
		])
	}
	
	func startAnimating() {
		isHidden = false
		activitiIndicatorView.startAnimating()
	}
	
	func stopAnimating() {
		isHidden = true
		activitiIndicatorView.stopAnimating()
	}
}
