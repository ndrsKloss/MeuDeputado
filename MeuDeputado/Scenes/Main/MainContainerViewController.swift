import UIKit
import RxSwift

final class MainContainerViewController: UIViewController {
	
	typealias Input = MainContainerViewModel.Input
	
	private let viewModel: MainContainerViewModel
	
	private var visualization: Visualization?
	
	private let disposeBag = DisposeBag()
	
	private let switchOptionView = SwitchOptionView()
	
	private let mainContentPlaceholderView = UIView()
	
	private var guide: UILayoutGuide {
		view.safeAreaLayoutGuide
	}
	
	private var margins: UILayoutGuide {
		view.layoutMarginsGuide
	}
	
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
	
	private func configureMainContent(_ viewModels: [MainContentViewModel]) {
		assert(viewModels.count == 2)
		viewModels.forEach(configureEachMainContent)
	}
	
	private func configureEachMainContent(viewModel: MainContentViewModel) {
		var viewControllers = [UIViewController]()
		
		func configure(_ viewModel: MainContentViewModel) {
			let viewController = MainContentViewController(viewModel: viewModel)
			view.addSubview(viewController.view, withConstraints: true)
			viewController.didMove(toParent: self)
			viewControllers.append(viewController)

			NSLayoutConstraint.activate([
				viewController.view.topAnchor.constraint(equalTo: switchOptionView.bottomAnchor),
				viewController.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
				margins.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
				guide.bottomAnchor.constraint(equalToSystemSpacingBelow: viewController.view.bottomAnchor, multiplier: 1.0)
			])
		}
		
		self.visualization = Visualization(left: viewControllers[0], right: viewControllers[1])
	}
	
	private func transform() {
		let input = Input(
			viewWillAppear: rx.viewWillAppear,
			leftTap: switchOptionView.rx.leftTap,
			rightTap: switchOptionView.rx.rightTap
		)
		
		let output = viewModel.transform(input: input)

		output.rawContent
			.drive(onNext: configureMainContent)
			.disposed(by: disposeBag)
	}
}

extension MainContainerViewController {
	private struct Visualization {
		enum Side { case left; case right }
		
		var viewControllers = [UIViewController]()
		
		init (left: UIViewController, right: UIViewController) {
			viewControllers.append(contentsOf: [left, right])
		}
		
		func contentOf(side: Side) -> UIViewController? {
			switch side {
				case .left: return viewControllers.first
				case .right: return viewControllers.last
			}
		}
	}
}
