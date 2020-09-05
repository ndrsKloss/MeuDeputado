import UIKit

protocol Coordinator {
  func start()
}

final class AppCoordinator: Coordinator {
  
  let window: UIWindow
  let rootViewController: UINavigationController
  
  init(window: UIWindow) {
    self.window = window
    rootViewController = UINavigationController()
  }
  
  func start() {
    
  }
}
