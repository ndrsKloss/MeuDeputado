// @sergdort
protocol ViewModelType {
	associatedtype Constants
    associatedtype Input
    associatedtype Output
	
    func transform(input: Input) -> Output
}
