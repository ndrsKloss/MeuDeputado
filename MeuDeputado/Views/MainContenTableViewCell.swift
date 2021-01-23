import RxSwift
import UIKit

final class MainContenTableViewCell: UITableViewCell {

  typealias Style = MainContentTableViewCellModel.Style

  typealias Input = MainContentTableViewCellModel.Input

  private var disposeBag = DisposeBag()

  private let mainContentView = MainContentView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier
    )

    configureSelf()
    configureMainContentView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    return nil
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    mainContentView.imageView.image = nil
  }

  private func configureSelf() {
    backgroundColor = .neutralLighter
    selectionStyle = .none
  }

  private func configureMainContentView() {
    contentView.addSubviewWithAutolayout(mainContentView)

    NSLayoutConstraint.activate([
      mainContentView.topAnchor.constraint(
        equalTo: contentView.topAnchor, constant: Spacing.medium),
      mainContentView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: Spacing.large),
      contentView.trailingAnchor.constraint(
        equalTo: mainContentView.trailingAnchor, constant: Spacing.large),
      contentView.bottomAnchor.constraint(
        equalTo: mainContentView.bottomAnchor, constant: Spacing.large),
    ])
  }

  private func configureMainContentViewStyle(style: Style) {
    switch style {
    case .deputy: mainContentView.apply(style: .deputy)
    case .party: mainContentView.apply(style: .party)
    }
  }

  func configure(withViewModel viewModel: MainContentTableViewCellModel) {
    let output = viewModel.transform(input: Input())

    output.style
      .drive(onNext: configureMainContentViewStyle)
      .disposed(by: disposeBag)

    output.title
      .drive(mainContentView.title.rx.text)
      .disposed(by: disposeBag)

    output.information
      .drive(mainContentView.information.rx.text)
      .disposed(by: disposeBag)

    output.image
      .drive(mainContentView.imageView.rx.image)
      .disposed(by: disposeBag)
  }
}
