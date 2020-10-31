import UIKit
import RxSwift

final class MainContainerViewController:
	UIViewController,
	LoaderAndErrorPresentable {

	typealias Input = MainContainerViewModel.Input
	
	private let viewModel: MainContainerViewModel
	
	private var visualization = Visualization()
	
	private let disposeBag = DisposeBag()
	
	private let switchOptionView = SwitchOptionView()
	
	init(
		viewModel: MainContainerViewModel = MainContainerViewModel(finder: Finder())
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
		configureSwitchOptionView()
		configureLoaderView()
		configureErrorView()
		transform()
	}
	
	private func configureSelf() {
		view.backgroundColor = .neutralLighter
		title = MainContainerViewModel.Constants.appName
	}
	
	private func configureSwitchOptionView() {
		view.addSubview(switchOptionView, withConstraints: true)
		
		NSLayoutConstraint.activate([
			switchOptionView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
			switchOptionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(equalTo: switchOptionView.trailingAnchor),
		])
	}
	
	private func configureMainContent(
		_ viewModel: MainContentViewModel
	) {
		let viewController = MainContentViewController(viewModel: viewModel)
		
		viewController.view.isHidden = true
		
		view.addSubview(viewController.view, withConstraints: true)
		viewController.didMove(toParent: self)

		NSLayoutConstraint.activate([
			viewController.view.topAnchor.constraint(equalTo: switchOptionView.bottomAnchor),
			viewController.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
			guide.bottomAnchor.constraint(equalToSystemSpacingBelow: viewController.view.bottomAnchor, multiplier: 1.0)
		])
		
		visualization.viewControllers.append(viewController)
	}
	
	private func configureSuccess() {
		
	}
	
	private func configureLoading() {
		
	}
	
	private func configureError() {
		
	}
	
	private func transform() {
		let input = Input(
			viewWillAppear: rx.viewWillAppear,
			retryTap: errorView.rx.tap,
			leftTap: switchOptionView.rx.leftTap,
			rightTap: switchOptionView.rx.rightTap
		)
		
		let output = viewModel.transform(input: input)
		
		output.deputyContent
			.drive(onNext: configureMainContent)
			.disposed(by: disposeBag)
		
		output.partyContent
			.drive(onNext: configureMainContent)
			.disposed(by: disposeBag)
		
		output.state
			.filter { $0 == .success }
		
		output.state
			.filter { $0 == .error }

		output.state
			.filter { $0 == .loading }
	}
}

extension MainContainerViewController {
	private struct Visualization {
		enum Side { case left, right }
		
		var viewControllers = [UIViewController]()
		
		func contentOf(side: Side) -> UIViewController? {
			switch side {
				case .left: return viewControllers.first
				case .right: return viewControllers.last
			}
		}
	}
}
