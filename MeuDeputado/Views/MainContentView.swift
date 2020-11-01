import UIKit
import RxSwift
import RxCocoa

final class MainContentView: UIView {
	
	fileprivate lazy var animator = UIViewPropertyAnimator.runningPropertyAnimator(
		withDuration: 0.3,
		delay: 0,
		options: .curveLinear,
		animations: { self.imageView.alpha = 1.0 })
	
	private let imageStackView: UIStackView = {
		$0.axis = .horizontal
		$0.distribution = .fillProportionally
		$0.spacing = Spacing.medium
		return $0
	}(UIStackView())
	
	private let informationStackView: UIStackView = {
		$0.axis = .vertical
		$0.spacing = Spacing.xsmall
		return $0
	}(UIStackView())
	
	let imageView: UIImageView = {
		$0.alpha = 0.0
		$0.clipsToBounds = true
		$0.contentMode = .scaleAspectFit
		return $0
	}(UIImageView())
	
	let title: UILabel = {
		$0.numberOfLines = 0
		$0.font = .subhead
		$0.adjustsFontForContentSizeCategory = true
		return $0
	}(UILabel())
	
	let information: UILabel = {
		$0.numberOfLines = 0
		$0.font = .body
		$0.adjustsFontForContentSizeCategory = true
		return $0
	}(UILabel())

	init() {
		super.init(frame: .zero)
		configureSelf()
		configureImageView()
		configureImageStackView()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		return nil
	}
	
	private func configureSelf() {
		backgroundColor = .neutralLighter 
	}
	
	private func configureImageView() {
		//let height = imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 55.0)
		let height = imageView.heightAnchor.constraint(equalToConstant: 55.0)
		let width = imageView.widthAnchor.constraint(equalToConstant: 55.0)
		
		NSLayoutConstraint.activate([height, width])

		imageView.layer.cornerRadius = Radius.circular(width: width.constant, height: height.constant)
		imageView.clipsToBounds = true
	}
	
	private func configureImageStackView() {
		addSubviewWithAutolayout(imageStackView)
		
		NSLayoutConstraint.activate([
			imageStackView.topAnchor.constraint(equalTo: topAnchor),
			imageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			trailingAnchor.constraint(equalTo: imageStackView.trailingAnchor),
			bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor)
		])
	}
}

extension MainContentView: Styleable {
	enum MainContentViewStyle {
		case deputy, party
	}
	
	func apply(style: MainContentViewStyle) {
		switch style {
			case .deputy: configureForDeputy()
			case .party: configureForParty()
		}
	}
	
	private func configureForDeputy() {
		imageStackView.addArrangedSubview(imageView)
		imageStackView.addArrangedSubview(informationStackView)
		informationStackView.addArrangedSubview(title)
		informationStackView.addArrangedSubview(information)
	}
	
	private func configureForParty() {
		imageStackView.addArrangedSubview(informationStackView)
		informationStackView.addArrangedSubview(title)
		informationStackView.addArrangedSubview(information)
	}
}

extension Reactive where Base: MainContentView {
    
    /// Bindable sink for `image` property.
    var image: Binder<UIImage?> {
        return Binder(base) { view, image in
			view.imageView.image = image
			self.base.animator.startAnimation()
        }
    }
}
