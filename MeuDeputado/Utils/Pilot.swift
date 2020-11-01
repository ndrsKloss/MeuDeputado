// thx @virgilius-santos for the insight 🙇‍♂️
public class Pilot<D: Hashable> {
    public var destination: D
    public var luggage: Any?

    public init(destination: D, luggage: Any? = nil) {
        self.destination = destination
        self.luggage = luggage
    }

    public func getLuggage<T>() -> T? {
        luggage as? T
    }
}
