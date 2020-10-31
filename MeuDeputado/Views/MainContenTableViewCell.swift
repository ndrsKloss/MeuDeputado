import UIKit
import RxSwift

final class MainContenTableViewCell: UITableViewCell {
	
	private var disposeBag = DisposeBag()
	
	private let mainContentView = MainContentView()
	
	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(
			style: style,
			reuseIdentifier: reuseIdentifier
		)
		
		configureSelf()
		configureMainContentView()
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
	}
	
	private func configureMainContentView() {
		addSubviewWithAutolayout(mainContentView)
		
		NSLayoutConstraint.activate([
			mainContentView.topAnchor.constraint(equalTo: topAnchor),
			mainContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
			bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor)
		])
	}
	
	func configure(withViewModel viewModel: MainContentTableViewCellModel) {
		
	}
}
