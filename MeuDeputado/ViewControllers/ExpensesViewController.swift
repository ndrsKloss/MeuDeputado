import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Parse

final class ExpensesViewController: UIViewController {
	
	typealias Input = ExpensesViewModel.Input
	
	private let viewModel: ExpensesViewModel
    
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        $0.separatorColor = .neutralBase
        $0.backgroundColor = .neutralLighter
        $0.showsVerticalScrollIndicator = false
        $0.separatorInset = UIEdgeInsets.zero
        $0.tableFooterView = UIView()
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.register(TotalExpensesTableViewCell.self)
        return $0
    }(UITableView())
	
	init(
		viewModel: ExpensesViewModel
	) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(
		coder aDecoder: NSCoder
	) {
		return nil
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		configureSelf()
        configureTableView()
		transform()
	}

	private func configureSelf() {
		view.backgroundColor = .neutralLighter
	}
	
    private func configureTableView() {
        view.addSubviewWithAutolayout(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            guide.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1.0)
        ])
    }
    
	private func transform() {
		let output = viewModel.transform(input: Input())
        
        output
            .dataSource
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
	}
}

extension ExpensesViewController {
    var dataSource: RxTableViewSectionedReloadDataSource<ExpensesSectionModel> {
        RxTableViewSectionedReloadDataSource<ExpensesSectionModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
            
            switch dataSource[indexPath] {
                
            case .total(let viewModel):
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: TotalExpensesTableViewCell.self),
                    for: indexPath
                )
                
                if let cell = cell as? TotalExpensesTableViewCell {
                    cell.configure(withViewModel: viewModel)
                    return cell
                }
                
                return cell
            }
        })
    }
}
