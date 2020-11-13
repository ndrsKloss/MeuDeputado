import UIKit
import RxSwift
import RxCocoa
import Charts

final class TypeExpensesTableViewCell: UITableViewCell {
    
    private let expenseChartView = ExpenseChartView()
    
    private var disposeBag = DisposeBag()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        configureSelf()
        condigureExpenseChartView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureSelf() {
        backgroundColor = .neutralLighter
        selectionStyle = .none
    }
    
    private func condigureExpenseChartView() {
        contentView.addSubviewWithAutolayout(expenseChartView)
        
        NSLayoutConstraint.activate([
            expenseChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            expenseChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            expenseChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.xlarge),
            contentView.trailingAnchor.constraint(equalTo: expenseChartView.trailingAnchor, constant: Spacing.xlarge),
            contentView.bottomAnchor.constraint(equalTo: expenseChartView.bottomAnchor)
        ])
    }
    
    func configure(withViewModel viewModel: TypeExpensesTableViewCellModel) { }
        
}
