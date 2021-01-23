import Keys
import Parse
import XCTest

@testable import MeuDeputado

final class ParseAppDelegateTest: XCTestCase {

  func testConfiguration() throws {
    let (sut, fields) = makeSut()

    _ = sut.application(
      UIApplication.shared,
      didFinishLaunchingWithOptions: nil
    )

    let config = try XCTUnwrap(fields.config.spy)

    XCTAssertEqual(config.applicationId, String?(fields.keys.meuDeputadoId))
    XCTAssertEqual(config.clientKey, String?(fields.keys.meuDeputadoAPIClientKey))
    XCTAssertEqual(config.server, String?("server"))
  }
}

extension ParseAppDelegateTest {
  typealias Sut = ParseAppDelegate
  typealias Fields = (
    config: ConfigSpy,
    keys: MeuDeputadoKeysMock
  )

  final class ConfigSpy {
    var spy: ParseClientConfiguration?

    lazy var parserInitialize: (ParseClientConfiguration) -> Void = {
      [weak self] parseClientConfiguration in
      self?.spy = parseClientConfiguration
    }
  }

  final class MeuDeputadoKeysMock: MeuDeputadoKeys {
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
