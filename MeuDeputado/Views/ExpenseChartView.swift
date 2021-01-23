import Charts
import RxCocoa
import RxSwift
import UIKit

final class ExpenseChartView: UIView {

  private let stackView: UIStackView = {
    $0.alignment = .leading
    $0.spacing = Spacing.medium
    return $0
  }(UIStackView())

  let expenseTypeLabel: ExpenseChartLabel = {
    $0.apply(style: .expenseType)
    return $0
  }(ExpenseChartLabel())

  let expenseYearLabel: ExpenseChartLabel = {
    $0.apply(style: .year)
    return $0
  }(ExpenseChartLabel())

  let valueLabel: ExpenseChartLabel = {
    $0.apply(style: .value)
    return $0
  }(ExpenseChartLabel())

  let chartView: LineChartView = {
    $0.noDataText = ""
    $0.legend.enabled = false
    $0.xAxis.enabled = false
    $0.leftAxis.enabled = false
    $0.rightAxis.enabled = false
    $0.dragEnabled = true
    $0.setScaleEnabled(false)
    $0.pinchZoomEnabled = false
    return $0
  }(LineChartView())

  let baseStackView: UIStackView = {
    $0.alignment = .center
    $0.distribution = .equalCentering
    return $0
  }(UIStackView())

  private let _index = PublishSubject<Double>()
  private var months = [ExpenseChartLabel]()

  var index: Observable<Double> {
    _index.asObservable()
  }

  init() {
    super.init(frame: .zero)

    configureSelf()
    configureStackView()
    configureExpenseTypeLabel()
    configureExpenseYearLabel()
    configureValueLabel()
    configureChartView()
    configureBaseStackView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    return nil
  }

  private func configureSelf() {
    backgroundColor = .neutralLighter
  }

  private func configureStackView() {
    addSubviewWithAutolayout(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.medium),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      trailingAnchor.constraint(
        greaterThanOrEqualTo: stackView.trailingAnchor, constant: Spacing.medium),
    ])
  }

  private func configureExpenseTypeLabel() {
    stackView.addArrangedSubview(expenseTypeLabel)
  }

  private func configureExpenseYearLabel() {
    stackView.addArrangedSubview(expenseYearLabel)
  }

  private func configureValueLabel() {
    addSubviewWithAutolayout(valueLabel)

    NSLayoutConstraint.activate([
      valueLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Spacing.medium),
      valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: Spacing.medium),
    ])
  }

  private func configureChartView() {
    chartView.delegate = self
    addSubviewWithAutolayout(chartView)

    NSLayoutConstraint.activate([
      chartView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: Spacing.small),
      chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: Spacing.medium),

      chartView.heightAnchor.constraint(equalToConstant: 150.0),
    ])
  }

  private func configureBaseStackView() {
    addSubviewWithAutolayout(baseStackView)

    NSLayoutConstraint.activate([
      baseStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor),
      baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.medium),
      trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor, constant: Spacing.medium),
      bottomAnchor.constraint(equalTo: baseStackView.bottomAnchor),

      baseStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44.0),
    ])
  }

  func selectMonth(at index: Int) {
    let label = months[index]
    let indexOf = months.firstIndex(of: label)

    months.enumerated().forEach { index, element in
      if indexOf != index {
        element.apply(style: .chartBaseUnselected)
      }
    }

    label.apply(style: .chartBaseSelected)
  }

  func configureBaseStackView(_ months: [String]) {
    self.months.forEach {
      $0.removeFromSuperview()
      NSLayoutConstraint.deactivate($0.constraints)
    }

    self.months = []

    months.forEach {
      let label = ExpenseChartLabel()
      label.apply(style: .chartBaseUnselected)
      label.text = $0

      self.months.append(label)
      baseStackView.addArrangedSubview(label)
    }
  }
}

final class ExpenseChartLabel: UILabel {
  var contentEdgeInsets = UIEdgeInsets() {
    didSet {
      let rect = CGRect()
      rect.inset(by: contentEdgeInsets)
      drawText(in: rect)
    }
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + contentEdgeInsets.left + contentEdgeInsets.right,
      height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom
    )
  }
}

extension ExpenseChartLabel: Styleable {

  struct ExpenseChartLabelStyle {
    let borderColor: CGColor
    let borderWidth: CGFloat
    let backgroundColor: UIColor
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    let contentEdgeInsets: UIEdgeInsets

    static let expenseType = ExpenseChartLabelStyle(
      borderColor: UIColor.neutralDarker.cgColor,
      borderWidth: Thickness.small,
      backgroundColor: .neutralLighter,
      textColor: .neutralDarker,
      font: UIFont.callout2.withSize(FontSize.xsmall),
      textAlignment: .center,
      contentEdgeInsets: UIEdgeInsets(
        top: Spacing.xsmall, left: Spacing.small, bottom: Spacing.xsmall, right: Spacing.small)
    )

    static let year = ExpenseChartLabelStyle(
      borderColor: UIColor.clear.cgColor,
      borderWidth: Thickness.none,
      backgroundColor: .primary,
      textColor: .neutralLighter,
      font: UIFont.callout2.withSize(FontSize.xsmall),
      textAlignment: .center,
      contentEdgeInsets: UIEdgeInsets(
        top: Spacing.xsmall, left: Spacing.small, bottom: Spacing.xsmall, right: Spacing.small)
    )

    static let value = ExpenseChartLabelStyle(
      borderColor: UIColor.clear.cgColor,
      borderWidth: Thickness.none,
      backgroundColor: .neutralLighter,
      textColor: .neutralDarker,
      font: UIFont.title3.withSize(FontSize.medium),
      textAlignment: .left,
      contentEdgeInsets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    )

    static let chartBaseSelected = ExpenseChartLabelStyle(
      borderColor: UIColor.clear.cgColor,
      borderWidth: Thickness.none,
      backgroundColor: .neutralLighter,
      textColor: .primary,
      font: UIFont.title3.withSize(FontSize.xsmall),
      textAlignment: .center,
      contentEdgeInsets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    )

    static let chartBaseUnselected = ExpenseChartLabelStyle(
      borderColor: UIColor.clear.cgColor,
      borderWidth: Thickness.none,
      backgroundColor: .neutralLighter,
      textColor: .neutralDarker,
      font: UIFont.headline.withSize(FontSize.xsmall),
      textAlignment: .center,
      contentEdgeInsets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    )
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = Radius.circular(self.bounds)
    layer.masksToBounds = true
  }

  func apply(style: ExpenseChartLabelStyle) {
    layer.borderColor = style.borderColor
    layer.borderWidth = style.borderWidth
    backgroundColor = style.backgroundColor
    textColor = style.textColor
    font = style.font
    textAlignment = style.textAlignment
    contentEdgeInsets = style.contentEdgeInsets
  }
}

extension ExpenseChartView: ChartViewDelegate {
  func chartValueSelected(
    _ chartView: ChartViewBase,
    entry: ChartDataEntry,
    highlight: Highlight
  ) {
    _index.onNext(entry.x)
  }
}

extension ExpenseChartView: Styleable {
  struct ExpenseChartViewStyle {
    let cornerRadious: CGFloat
    let shadowOpacity: Float
    let shadowOffset: CGSize
    let shadowRadius: CGFloat

    static let type = ExpenseChartViewStyle(
      cornerRadious: Radius.small,
      shadowOpacity: Shadow.Large.shadowOpacity,
      shadowOffset: Shadow.Large.shadowOffset,
      shadowRadius: Shadow.Large.shadowRadius
    )
  }

  func apply(style: ExpenseChartViewStyle) {
    layer.cornerRadius = style.cornerRadious
    layer.shadowOpacity = style.shadowOpacity
    layer.shadowOffset = style.shadowOffset
    layer.shadowRadius = style.shadowRadius
  }
}
