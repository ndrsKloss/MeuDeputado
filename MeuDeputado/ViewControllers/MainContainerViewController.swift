import Parse
import RxSwift
import UIKit

final class MainContainerViewController:
  UIViewController,
  LoaderAndErrorPresentable
{

  typealias Input = MainContainerViewModel.Input

  private let viewModel: MainContainerViewModel

  private var visualization = Visualization()

  private let switchOptionView = SwitchOptionView()

  private var loaderView: LoaderView?

  private var errorView: ErrorView?

  let disposeBag = DisposeBag()

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
      switchOptionView.topAnchor.constraint(
        equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
      switchOptionView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor, constant: Spacing.large),
      view.trailingAnchor.constraint(
        equalTo: switchOptionView.trailingAnchor, constant: Spacing.large),
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
      viewController.view.topAnchor.constraint(
        equalTo: switchOptionView.bottomAnchor, constant: Spacing.large),
      viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
      guide.bottomAnchor.constraint(
        equalToSystemSpacingBelow: viewController.view.bottomAnchor, multiplier: 1.0),
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

  private func changeToLeftVisualization() {
    visualization.rightView?.isHidden = true
    visualization.leftView?.isHidden = false

  }

  private func changeToRightVisualization() {
    visualization.leftView?.isHidden = true
    visualization.rightView?.isHidden = false
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
      .drive(onNext: { [unowned self] in
        self.configureMainContent($0)
      })
      .disposed(by: disposeBag)

    output.partyContent
      .drive(onNext: { [unowned self] in
        self.configureMainContent($0)
      })
      .disposed(by: disposeBag)

    output.status
      .drive(onNext: { [unowned self] in
        self.configureState($0)
      })
      .disposed(by: disposeBag)

    switchOptionView.rx.leftTap
      .subscribe(onNext: { [unowned self] in
        self.changeToLeftVisualization()
      })
      .disposed(by: disposeBag)

    switchOptionView.rx.rightTap
      .subscribe(onNext: { [unowned self] in
        self.changeToRightVisualization()
      })
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
