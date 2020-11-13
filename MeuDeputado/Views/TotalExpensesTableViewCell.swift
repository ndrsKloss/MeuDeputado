import UIKit
import RxSwift
import RxCocoa
import Charts

final class TotalExpensesTableViewCell: UITableViewCell {
    
    typealias Constants = TotalExpensesTableViewCellModel.Constants
    
    typealias Input = TotalExpensesTableViewCellModel.Input
    
    private var disposeBag = DisposeBag()
    
    private let information: UILabel = {
        $0.numberOfLines = 0
        $0.font = .body
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    private let expenseChartView = ExpenseChartView()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        configureSelf()
        configureInformation()
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
    
    private func configureInformation() {
        contentView.addSubviewWithAutolayout(information)
        
        NSLayoutConstraint.activate([
            information.topAnchor.constraint(equalTo: contentView.topAnchor),
            information.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            contentView.trailingAnchor.constraint(equalTo: information.trailingAnchor, constant: Spacing.medium),
        ])
    }
    
    private func condigureExpenseChartView() {
        expenseChartView.expenseTypeLabel.text = Constants.expenseType
        
        contentView.addSubviewWithAutolayout(expenseChartView)
        
        NSLayoutConstraint.activate([
            expenseChartView.topAnchor.constraint(equalTo: information.bottomAnchor, constant: Spacing.large),
            expenseChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.xlarge),
            contentView.trailingAnchor.constraint(equalTo: expenseChartView.trailingAnchor, constant: Spacing.xlarge),
            contentView.bottomAnchor.constraint(equalTo: expenseChartView.bottomAnchor)
        ])
    }
    
    func configure(withViewModel viewModel: TotalExpensesTableViewCellModel) {
        let input = Input(
            index: expenseChartView.index
        )
        
        let output = viewModel.transform(input: input)
        
        output.year
            .drive(onNext: { [unowned self] in
                self.expenseChartView.expenseYearLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        output.information
            .drive(information.rx.text)
            .disposed(by: disposeBag)
        
        output.chartData
            .drive(onNext: { [unowned self] in
                self.expenseChartView.chartView.data = $0
            })
            .disposed(by: disposeBag)
        
        output.value
            .drive(onNext: { [unowned self] in
                self.expenseChartView.valueLabel.text = $0
            })
            .disposed(by: disposeBag)
    }
}
