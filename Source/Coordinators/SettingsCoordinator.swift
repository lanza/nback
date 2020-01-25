import UIKit

class SettingsCoordinator: Coordinator {
  var settingsViewController: SettingsViewController {
    return viewController as! SettingsViewController
  }

  override func loadViewController() {
    viewController = SettingsViewController()

    settingsViewController.title = Lets.settingsl10n
    settingsViewController.tabBarItem.title = Lets.settingsl10n
    settingsViewController.tabBarItem.image = nil
  }

  func viewController(_: ViewController, didCancelWith _: Any?) {}
  func viewController(_: ViewController, didFinishWith _: Any?) {}
  func viewController(_: ViewController, shouldSegueWith _: Any?) {}
}

class SettingsViewController: UIViewController {}
