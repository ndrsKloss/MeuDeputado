import UIKit
import RxSwift
import RxCocoa
import Charts

final class TotalExpensesTableViewCell: UITableViewCell {
    
    typealias Constants = TotalExpensesTableViewCellModel.Constants
    
    typealias Input = TotalExpensesTableViewCellModel.Input
    
    private let information: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.body.withSize(FontSize.large)
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    private let expenseChartView = ExpenseChartView()
    
    private var disposeBag = DisposeBag()
    
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
            expenseChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            contentView.trailingAnchor.constraint(equalTo: expenseChartView.trailingAnchor, constant: Spacing.medium),
            contentView.bottomAnchor.constraint(equalTo: expenseChartView.bottomAnchor)
        ])
    }
    
    func configure(withViewModel viewModel: TotalExpensesTableViewCellModel) {
        guard !viewModel.alreadyConfigured else { return }
        viewModel.alreadyConfigured = true
        
        let input = Input(
            index: expenseChartView.index
        )
        
        let output = viewModel.transform(input: input)
        
        output.year
            .drive(expenseChartView.expenseYearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.information
            .drive(information.rx.text)
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
