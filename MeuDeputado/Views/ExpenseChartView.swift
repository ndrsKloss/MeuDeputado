import UIKit
import Charts

final class ExpenseChartView: UIView {
	
	private let typeExpenseLabel: UILabel = {
		$0.numberOfLines = 0
		$0.layer.borderColor = UIColor.neutralDarker.cgColor
		$0.layer.borderWidth = Thickness.small
		$0.font = .callout2
		$0.textColor = .neutralDarker
		return $0
	}(UILabel())
	
	private let yearExpenseLabel = ExpenseChartTextField()
	
	init() {
		super.init(frame: .zero)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
}

private final class ExpenseChartTextField: UIButton { }

extension ExpenseChartView: Styleable {
	
	struct ExpenseChartTextStyle { }
	
    func apply(style: ExpenseChartTextStyle) { }
}
