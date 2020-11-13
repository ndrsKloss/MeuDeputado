import UIKit
import Charts
import RxSwift
import RxCocoa

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
        $0.leftAxis.axisMinimum = 0.0
        $0.rightAxis.axisMinimum = 0.0
        //$0.setViewPortOffsets(left: 0.0, top: 0.0, right: 0.0, bottom: 8.0)
        $0.legend.enabled = false
        //$0.delegate = self
        $0.xAxis.enabled = false
        $0.leftAxis.enabled = false
        $0.rightAxis.enabled = false
        $0.dragEnabled = true
        $0.setScaleEnabled(false)
        $0.pinchZoomEnabled = false
        return $0
    }(LineChartView())
	
    private let _index = PublishSubject<Double>()
    
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
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor),
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
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
        ])
    }
    
    private func configureChartView() {
        chartView.delegate = self
        addSubviewWithAutolayout(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: Spacing.small),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
            bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
            
            chartView.heightAnchor.constraint(equalToConstant: 70.0)
        ])
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
            font: .callout2,
            textAlignment: .center,
            contentEdgeInsets: UIEdgeInsets(top: Spacing.xsmall, left: Spacing.small, bottom: Spacing.xsmall, right: Spacing.small)
        )
        
        static let year = ExpenseChartLabelStyle(
            borderColor: UIColor.clear.cgColor,
            borderWidth: Thickness.none,
            backgroundColor: .primary,
            textColor: .neutralLighter,
            font: .callout2, textAlignment: .center,
            contentEdgeInsets: UIEdgeInsets(top: Spacing.xsmall, left: Spacing.small, bottom: Spacing.xsmall, right: Spacing.small)
        )
        
        static let value = ExpenseChartLabelStyle(
            borderColor: UIColor.clear.cgColor,
            borderWidth: Thickness.none,
            backgroundColor: .neutralLighter,
            textColor: .neutralDarker,
            font: .title3,
            textAlignment: .left,
            contentEdgeInsets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        )
        
        static let chartBaseSelected = ExpenseChartLabelStyle(
            borderColor: UIColor.clear.cgColor,
            borderWidth: Thickness.none,
            backgroundColor: .neutralLighter,
            textColor: .primary,
            font: .title3,
            textAlignment: .center,
            contentEdgeInsets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        )
        
        static let chartBaseUnselected = ExpenseChartLabelStyle(
            borderColor: UIColor.clear.cgColor,
            borderWidth: Thickness.none,
            backgroundColor: .neutralLighter,
            textColor: .neutralDarker,
            font: .headline,
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
