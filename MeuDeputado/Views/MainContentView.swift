import UIKit

final class MainContentView: UIView {
	
	private let imageStackView: UIStackView = {
		$0.axis = .horizontal
		return $0
	}(UIStackView())
	
	private  let informationStackView: UIStackView = {
		$0.axis = .vertical
		return $0
	}(UIStackView())
	
	let imageView = UIImageView()
	let title = UILabel()
	let information = UILabel()
	
	init() {
		super.init(frame: .zero)
		configureSelf()
		configureImageStackView()
		configureInformationStackView()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	private func configureSelf() {
		backgroundColor = .neutralLighter
	}
	
	private func configureImageStackView() {
		addSubviewWithAutolayout(imageStackView)
		
		NSLayoutConstraint.activate([
			imageStackView.topAnchor.constraint(equalTo: topAnchor),
			imageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: imageStackView.trailingAnchor),
			bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor)
		])
		
		imageStackView.addArrangedSubview(imageView)
		imageStackView.addArrangedSubview(informationStackView)
	}
	
	private func configureInformationStackView() {
		informationStackView.addArrangedSubview(title)
		informationStackView.addArrangedSubview(information)
	}
}
