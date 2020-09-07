import UIKit

let appDelegateClass: AnyClass =
  NSClassFromString("TestShortcut") ?? AppDelegate.self

UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  nil,
  NSStringFromClass(appDelegateClass)
)
