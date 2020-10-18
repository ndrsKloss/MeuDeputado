import Foundation

final class TwoOptionsContainerViewModel: ViewModelType {

	struct Constants {
		static let appName = NSLocalizedString("App-Name", comment: "")
		static let leftButtonTitle = NSLocalizedString("Deputy", comment: "")
		static let rightButtonTitle = NSLocalizedString("Party", comment: "")
	}
	
	struct Input { }
	
	struct Output { }
	
	func transform(input: Input) -> Output {
		Output()
	}
}

