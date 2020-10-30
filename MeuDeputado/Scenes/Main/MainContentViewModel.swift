final class MainContentViewModel: ViewModelType {
	
	struct Constants { }
	
	struct Input { }
	
	struct Output { }
	
	private let deputies: [Deputy]
	private let preparer: MainContentRepresentable
	
	init(
		deputies: [Deputy],
		preparer: MainContentRepresentable
	) {
		self.deputies = deputies
		self.preparer = preparer
	}
	
	func transform(input: Input) -> Output {
		Output()
	}
}

