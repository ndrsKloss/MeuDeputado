import XCTest
import Parse
@testable
import MeuDeputado

final class DeputyTests: XCTestCase {
	
	var deputy: Deputy!
	
	override static func setUp() {
		Parse.initialize(with: ParseClientConfiguration {
			$0.applicationId = "dummy_applicationId"
			$0.clientKey = "dummy_clientKey"
			$0.server = "dummy_server"
		})
	}
	
	override func setUp() {
		let deputy = Deputy(
			deputyId: 178835,
			name: "AFONSO MOTTA",
			realName: "AFONSO ANTUNES DA MOTTA",
			email: "dep.afonsomotta@camara.leg.br",
			party: "PDT",
			uf: "RS",
			ownership: 1
		)
		
		self.deputy = deputy
	}
	
	func testParseClassName() {
		XCTAssertEqual(Deputy.parseClassName(), "Deputy")
	}
}
