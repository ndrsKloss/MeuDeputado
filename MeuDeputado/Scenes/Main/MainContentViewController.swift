import UIKit
import RxSwift

final class MainContentViewController: UIViewController {
	
	typealias Constants = MainContentViewModel.Constants
	
	typealias Input = MainContentViewModel.Input
	
	private let viewModel: MainContentViewModel
	
	private let disposeBag = DisposeBag()
	
	private let tableView: UITableView = {
		$0.showsVerticalScrollIndicator = false
		$0.backgroundColor = .neutralLighter
		$0.tableFooterView = UIView()
		$0.estimatedRowHeight = UITableView.automaticDimension
		return $0
	}(UITableView())
	
	init(
		viewModel: MainContentViewModel
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
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
			view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
		])
	}
	
	private func transform() {
		let configureCell = { (tableView: UITableView, _: Int, viewModel: MainContentTableViewCellModel) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainContentCellIdentifier) as? MainContenTableViewCell ??
				
				MainContenTableViewCell(style: .default, reuseIdentifier: Constants.mainContentCellIdentifier)
			
			cell.configure(withViewModel: viewModel)
			
			return cell
		}
		
		let input = Input()

		let output = viewModel.transform(input: input)
		
		output
			.dataSource
			.drive(tableView.rx.items)(configureCell)
			.disposed(by: disposeBag)
	}
}
