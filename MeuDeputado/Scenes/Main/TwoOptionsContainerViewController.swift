import UIKit
import RxSwift

final class TwoOptionsContainerViewController: UIViewController {
	
	private let viewModel: TwoOptionsContainerViewModel
	
	private let containerView = TwoOptionsContainerView()
	
	init(viewModel: TwoOptionsContainerViewModel = TwoOptionsContainerViewModel()) {
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
		configureContainerView()
		configureConstans()
	}
	
	private func configureSelf() {
		view.backgroundColor = .neutralLighter
	}
	
	private func configureContainerView() {
		view.addSubview(containerView, withConstraints: true)
		
		let guide = view.safeAreaLayoutGuide
		let margins = view.layoutMarginsGuide
		
		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			containerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			guide.bottomAnchor.constraint(equalToSystemSpacingBelow: containerView.bottomAnchor, multiplier: 1.0)
		])
	}
	
	private func configureConstans() {
		title = TwoOptionsContainerViewModel.Constants.appName
	}
}
