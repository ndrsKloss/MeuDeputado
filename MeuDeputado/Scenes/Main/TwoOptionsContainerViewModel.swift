import Foundation

final class TwoOptionsContainerViewModel: ViewModelType {

	struct Constants {
		static let appName = NSLocalizedString("App-Name", comment: "")
	}
	
	struct Input { }
	
	struct Output { }
	
	func transform(input: Input) -> Output {
		Output()
	}
}

