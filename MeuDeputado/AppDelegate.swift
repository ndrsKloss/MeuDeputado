import Foundation
import UIKit
import Keys
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  private let thirdPartyServices = [
    ParseAppDelegate()
   ]
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    defer { window?.makeKeyAndVisible() }
    
    for services in thirdPartyServices {
      _ = services.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
      )
    }

    self.window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = ViewController()
    window?.rootViewController = viewController
    
    return true
  }
}

private final class ParseAppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let keys = MeuDeputadoKeys()
    
    let clientConfiguration = ParseClientConfiguration {
      $0.applicationId = keys.meuDeputadoId
      $0.clientKey = keys.meuDeputadoAPIClientKey
      $0.server = "https://parseapi.meudeputado.mobi/parse/"
    }
    
    Parse.initialize(with: clientConfiguration)
    
    return true
  }
}
