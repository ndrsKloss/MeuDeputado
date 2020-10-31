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
	
	private var loaderView: LoaderView?
	
	private var errorView: ErrorView?
	
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
		loaderView = configureLoaderView()
		errorView = configureErrorView()
		transform()
	}
	
	private func configureSelf() {
		view.backgroundColor = .neutralLighter
		title = MainContainerViewModel.Constants.appName
	}
	
	private func configureSwitchOptionView() {
		view.addSubviewWithAutolayout(switchOptionView)
		
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
		
		view.addSubviewWithAutolayout(viewController.view)
		viewController.didMove(toParent: self)

		NSLayoutConstraint.activate([
			viewController.view.topAnchor.constraint(equalTo: switchOptionView.bottomAnchor),
			viewController.view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			margins.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
			guide.bottomAnchor.constraint(equalToSystemSpacingBelow: viewController.view.bottomAnchor, multiplier: 1.0)
		])
		
		visualization.viewControllers.append(viewController)
	}
	
	
	private func configureState(_ status: MainContainerViewModel.Status) {
		switch status {
			case .success: configureSuccess()
			case .loading: configureLoading()
			case .error: configureError()
		}
	}
	
	private func configureSuccess() {
		loaderView?.stopAnimating()
		errorView?.isHidden = true
		visualization.rightView?.isHidden = true
		
		switchOptionView.isHidden = false
		visualization.leftView?.isHidden = false
	}
	
	private func configureLoading() {
		switchOptionView.isHidden = true
		visualization.leftView?.isHidden = true
		visualization.rightView?.isHidden = true
		errorView?.isHidden = true
		
		loaderView?.startAnimating()
	}
	
	private func configureError() {
		loaderView?.stopAnimating()
		switchOptionView.isHidden = true
		visualization.leftView?.isHidden = true
		visualization.rightView?.isHidden = true
		
		errorView?.isHidden = false
	}
	
	private func transform() {
		let input = Input(
			viewWillAppear: rx.viewWillAppear,
			retryTap: errorView?.rx.tap ?? .init(events: Observable<Void>.empty()),
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
		
		output.status
			.drive(onNext: configureState)
			.disposed(by: disposeBag)
	}
}

extension MainContainerViewController {
	private struct Visualization {
		var viewControllers = [UIViewController]() {
			didSet {
				assert(viewControllers.count <= 2)
			}
		}
		
		var leftView: UIView? {
			viewControllers.first?.view
		}
		
		var rightView: UIView? {
			viewControllers.last?.view
		}
	}
}
