import UIKit
import RxSwift
import RxCocoa
import Charts

final class TypeExpensesTableViewCell: UITableViewCell {
    
    typealias Input = TypeExpensesTableViewCellModel.Input
    
    private let expenseChartView: ExpenseChartView = {
        $0.apply(style: .type)
        return $0
    }(ExpenseChartView())
    
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
    
    private func configureSelf() {
        contentView.backgroundColor = .primary
        selectionStyle = .none
    }
    
    private func condigureExpenseChartView() {
        contentView.addSubviewWithAutolayout(expenseChartView)
        
        NSLayoutConstraint.activate([
            expenseChartView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.small),
            expenseChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            contentView.trailingAnchor.constraint(equalTo: expenseChartView.trailingAnchor, constant: Spacing.medium),
            contentView.bottomAnchor.constraint(equalTo: expenseChartView.bottomAnchor, constant: Spacing.small)
        ])
    }
    
    func configure(withViewModel viewModel: TypeExpensesTableViewCellModel) {
        guard !viewModel.alreadyConfigured else { return }
        viewModel.alreadyConfigured = true
        
        let input = Input(
            index: expenseChartView.index
        )
        
        let output = viewModel.transform(input: input)
        
        output.year
            .drive(expenseChartView.expenseYearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.type
            .drive(expenseChartView.expenseTypeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.dataSet
            .drive(onNext: { [unowned self] in
                let data = LineChartData(dataSet: $0)
                self.expenseChartView.chartView.data = data
            })
            .disposed(by: disposeBag)
        
        output.entry
            .drive(onNext: { [unowned self] in
                self.expenseChartView.chartView.lineData?.removeDataSetByIndex(1)
                self.expenseChartView.chartView.lineData?.addDataSet($0)
            })
            .disposed(by: disposeBag)
        
        output.value
            .drive(expenseChartView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.months
            .drive(onNext: { [unowned self] in
                self.expenseChartView.configureBaseStackView($0)
            })
            .disposed(by: disposeBag)
        
        output.index
            .drive(onNext: { [unowned self] in
                self.expenseChartView.selectMonth(at: $0)
            })
            .disposed(by: disposeBag)
    }
        
}
