import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController.init(nibName: nil, bundle: nil)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

