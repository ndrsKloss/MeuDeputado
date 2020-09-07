import XCTest
@testable
import MeuDeputado

final class AppDelegateTest: XCTestCase {
  
  func testServicesCalled() {
    let (sut, fields) = makeSut()
    
    _ = sut.application(
      UIApplication.shared,
      didFinishLaunchingWithOptions: nil
    )
    
    XCTAssertTrue(fields[0].called)
    XCTAssertTrue(fields[1].called)
  }
}

extension AppDelegateTest {
  typealias Sut = AppDelegate
  typealias Fields = [AppDelegateSpy]
  
  class AppDelegateSpy:
  NSObject,
  UIApplicationDelegate {
    var called = false
    
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
      called = true
      
      return true
    }
  }
  
  func makeSut() -> (
    sut: Sut,
    fields: Fields
    ) {
      let spies = [
        AppDelegateSpy(),
        AppDelegateSpy()
      ]
      
      let sut = Sut(
        services: spies
      )
      
      return (sut, spies)
  }
}
