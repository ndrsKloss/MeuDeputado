import UIKit
import Keys
import Parse

final class AppDelegate:
	UIResponder,
	UIApplicationDelegate {
	
	private var services: [UIApplicationDelegate]
	
	override init() {
		
		var coordinator: CoordinatorAppDelegate
		
		#if DEBUG
		coordinator = CoordinatorAppDelegate(coordinator: FirstCoordinator())
		#else
		CoordinatorAppDelegate()
		#endif
		
		self.services = [
			ParseAppDelegate(),
			coordinator
		]
		super.init()
	}
	
	convenience init(
		services: [UIApplicationDelegate]
	) {
		self.init()
		self.services = services
	}
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
		for service in services {
			_ = service.application?(
				application,
				didFinishLaunchingWithOptions: launchOptions
			)
		}
		
		return true
	}
}

final class ParseAppDelegate:
	NSObject,
UIApplicationDelegate {
	
	private let applicationId: String
	private let clientKey: String
	private let server: String
	
	private let parserInitialize: (ParseClientConfiguration) -> Void
	
	init(
		parserInitialize: @escaping (ParseClientConfiguration) -> Void = Parse.initialize,
		keys: MeuDeputadoKeys = MeuDeputadoKeys(),
		server: String = "https://parseapi.meudeputado.mobi/parse/"
	) {
		
		self.parserInitialize = parserInitialize
		self.applicationId = keys.meuDeputadoId
		self.clientKey = keys.meuDeputadoAPIClientKey
		self.server = server
	}
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
		configureParse(
			applicationId,
			clientKey,
			server
		)
		
		return true
	}
	
	private func configureParse(
		_ applicationId: String,
		_ clientKey: String,
		_ server: String
	) {
		
		let clientConfiguration = ParseClientConfiguration { [applicationId, clientKey, server] in
			$0.applicationId = applicationId
			$0.clientKey = clientKey
			$0.server = server
		}
		
		parserInitialize(clientConfiguration)
	}
}

final class CoordinatorAppDelegate: NSObject, UIApplicationDelegate {
	var window: UIWindow?
	
	private let coordinator: Coordinatable
	
	init(
		coordinator: Coordinatable = MainCoordinator()
	) {
		self.coordinator = coordinator
	}
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		defer { window?.makeKeyAndVisible() }
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		coordinator.start()
		
		window?.rootViewController = coordinator.navigationController
		
		return true
	}
}
