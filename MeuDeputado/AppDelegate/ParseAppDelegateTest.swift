import XCTest
import Parse
import Keys
@testable
import MeuDeputado

final class ParseAppDelegateTest: XCTestCase {
  
  func testConfiguration() throws {
    let (sut, fields) = makeSut()
    
    _ = sut.application(
      UIApplication.shared,
      didFinishLaunchingWithOptions: nil
    )
    
    let config = try XCTUnwrap(fields.config.spy)
    
    XCTAssertEqual(config.applicationId, Optional<String>(fields.keys.meuDeputadoId))
    XCTAssertEqual(config.clientKey, Optional<String>(fields.keys.meuDeputadoAPIClientKey))
    XCTAssertEqual(config.server, Optional<String>("server"))
  }
}

extension ParseAppDelegateTest {
  typealias Sut = ParseAppDelegate
  typealias Fields = (
    config: ConfigSpy,
    keys: MeuDeputadoKeysMock
  )

  class ConfigSpy {
    var spy: ParseClientConfiguration?
    
    lazy var parserInitialize: (ParseClientConfiguration) -> Void = { [weak self] parseClientConfiguration in
      self?.spy = parseClientConfiguration
    }
  }
  
  class MeuDeputadoKeysMock: MeuDeputadoKeys {
    override var meuDeputadoId: String {
      "applicationId"
    }
    override var meuDeputadoAPIClientKey: String {
      "clientKey"
    }
  }
  
  func makeSut() -> (
    sut: Sut,
    fields: Fields
    ) {
      let configSpy = ConfigSpy()
      
      let meuDeputadoKeyMock = MeuDeputadoKeysMock()
      
      let sut = Sut(
        parserInitialize: configSpy.parserInitialize,
        keys: meuDeputadoKeyMock,
        server: "server"
      )
      
      return (sut, (configSpy, meuDeputadoKeyMock))
  }
}
