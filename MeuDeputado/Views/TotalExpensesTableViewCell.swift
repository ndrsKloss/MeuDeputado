import UIKit
import RxSwift
import RxCocoa

final class TotalExpensesTableViewCell: UITableViewCell {
    
    typealias Input = TotalExpensesTableViewCellModel.Input
    
    private var disposeBag = DisposeBag()
    
    private let title: UILabel = {
        $0.numberOfLines = 0
        $0.font = .largeTitle
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    private let information: UILabel = {
        $0.numberOfLines = 0
        $0.font = .body
        $0.adjustsFontForContentSizeCategory = true
        return $0
    }(UILabel())
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        configureSelf()
        configureTitle()
        configureInformation()
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
    
    private func configureTitle() {
        contentView.addSubviewWithAutolayout(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            contentView.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: Spacing.medium),
        ])
    }
    
    private func configureInformation() {
        contentView.addSubviewWithAutolayout(information)
        
        NSLayoutConstraint.activate([
            information.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Spacing.medium),
            information.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.medium),
            contentView.trailingAnchor.constraint(equalTo: information.trailingAnchor, constant: Spacing.medium),
            contentView.bottomAnchor.constraint(equalTo: information.bottomAnchor)
        ])
    }
    
    func configure(withViewModel viewModel: TotalExpensesTableViewCellModel) {
        let output = viewModel.transform(input: Input())
        
        output.title
            .drive(title.rx.text)
            .disposed(by: disposeBag)
        
        output.information
            .drive(information.rx.text)
            .disposed(by: disposeBag)
    }
}
