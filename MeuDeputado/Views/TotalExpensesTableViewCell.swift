import UIKit
import RxSwift
import RxCocoa
import Charts

final class TotalExpensesTableViewCell: UITableViewCell {
    
    typealias Constants = TotalExpensesTableViewCellModel.Constants
    
    typealias Input = TotalExpensesTableViewCellModel.Input
    
    private let roundedView: UIView = {
        $0.backgroundColor = .neutralLighter
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.cornerRadius = Radius.medium
        return $0
    }(UIView())
    
    private let information: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.body.withSize(FontSize.large)
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    private let compareButton: UIButton = {
        $0.backgroundColor = .blue
        $0.setTitle("Compare", for: .normal)
        return $0
    } (UIButton())
    
    private let expenseChartView = ExpenseChartView()
    
    private var disposeBag = DisposeBag()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        configureSelf()
        configureBackgroundView()
        configureInformation()
        configureCompareButton()
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
    
    private func configureBackgroundView() {
        contentView.addSubviewWithAutolayout(roundedView)
        
        NSLayoutConstraint.activate([
            roundedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            roundedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor)
        ])
    }
    
    private func configureInformation() {
        roundedView.addSubviewWithAutolayout(information)
        
        NSLayoutConstraint.activate([
            information.topAnchor.constraint(equalTo: contentView.topAnchor),
            information.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: Spacing.medium),
            roundedView.trailingAnchor.constraint(equalTo: information.trailingAnchor, constant: Spacing.medium),
        ])
    }
    
    private func configureCompareButton() {
        roundedView.addSubviewWithAutolayout(compareButton)
        
        NSLayoutConstraint.activate([
            compareButton.topAnchor.constraint(equalTo: information.bottomAnchor, constant: Spacing.small),
            compareButton.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: Spacing.medium),
            roundedView.trailingAnchor.constraint(greaterThanOrEqualTo: compareButton.trailingAnchor, constant: Spacing.medium)
        ])
    }
    
    private func condigureExpenseChartView() {
        expenseChartView.expenseTypeLabel.text = Constants.expenseType
        
        roundedView.addSubviewWithAutolayout(expenseChartView)
        
        NSLayoutConstraint.activate([
            expenseChartView.topAnchor.constraint(equalTo: compareButton.bottomAnchor, constant: Spacing.large),
            expenseChartView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: Spacing.medium),
            roundedView.trailingAnchor.constraint(equalTo: expenseChartView.trailingAnchor, constant: Spacing.medium),
            roundedView.bottomAnchor.constraint(equalTo: expenseChartView.bottomAnchor)
        ])
    }
    
    func configure(withViewModel viewModel: TotalExpensesTableViewCellModel) {
        let input = Input(
            index: expenseChartView.index,
            compareButtonTap: compareButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.year
            .drive(expenseChartView.expenseYearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.information
            .drive(information.rx.text)
            .disposed(by: disposeBag)
        
        output.lineChartData
            .drive(onNext: { [unowned self] in
                self.expenseChartView.chartView.data = $0
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
