import XCTest
@testable
import MeuDeputado

final class MainCoordinatorTests: XCTestCase {
	
	func test_TopSwiftReposViewControllerPushed() {
		let (sut, fields) = makeSut()
		sut.start()
		
		XCTAssertNotNil(fields.viewControllers.last)
		XCTAssert(fields.viewControllers.last is MainContainerViewController)
	}
}

extension MainCoordinatorTests {
	typealias Sut = MainCoordinator
	typealias Fields = UINavigationController
	
	final class navigationController: UINavigationController { }
	
	func makeSut() -> (
		sut: Sut,
		fields: Fields
		) {
			let navigationController = UINavigationController()
			let sut = Sut(navigationController: navigationController)
			return (sut, navigationController)
	}
}
