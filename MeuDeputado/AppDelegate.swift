import Foundation
import UIKit
import Keys
import Parse

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private let thirdPartyServices: [UIApplicationDelegate] = [
    ParseAppDelegate(),
    CoordinatorAppDelegate()
   ]
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    for services in thirdPartyServices {
      _ = services.application?(
        application,
        didFinishLaunchingWithOptions: launchOptions
      )
    }
    
    return true
  }
}

final class ParseAppDelegate: NSObject, UIApplicationDelegate {
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

final class CoordinatorAppDelegate: NSObject, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    defer { window?.makeKeyAndVisible() }
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = ViewController()
    window?.rootViewController = viewController
    
    return true
  }
}
