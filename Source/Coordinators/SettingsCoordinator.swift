import UIKit
import CoordinatorKit

class SettingsCoordinator: Coordinator {
  
  var settingsViewController: SettingsViewController { return viewController as! SettingsViewController }
  
  override func loadViewController() {
    viewController = SettingsViewController()
    
    settingsViewController.title = Lets.settingsl10n
    settingsViewController.tabBarItem.title = Lets.settingsl10n
    settingsViewController.tabBarItem.image = nil
  }
}


class SettingsViewController: UIViewController {
  
}
