import Foundation
import UIKit
import Keys
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    defer { window?.makeKeyAndVisible() }
    
    let keys = MeuDeputadoKeys()
    
    let clientConfiguration = ParseClientConfiguration {
      $0.applicationId = keys.meuDeputadoId
      $0.clientKey = keys.meuDeputadoAPIClientKey
      $0.server = "https://parseapi.meudeputado.mobi/parse/"
    }
    
    Parse.initialize(with: clientConfiguration)
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = ViewController()
    window?.rootViewController = viewController
    
    return true
  }
}

