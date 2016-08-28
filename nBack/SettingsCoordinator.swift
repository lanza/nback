import UIKit

class SettingsCoordinator: NSObject, NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    let settingsViewController = SettingsViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        settingsViewController.delegate = self
        settingsViewController.title = Lets.settingsl10n
        settingsViewController.tabBarItem.title = Lets.settingsl10n
        settingsViewController.tabBarItem.image = nil
    }
    
}

extension SettingsCoordinator: ViewControllerDelegate {
    func viewController(_ viewController: ViewController, didCancelWith thing: Any?) {    }
    func viewController(_ viewController: ViewController, didFinishWith thing: Any?) {    }
    func viewController(_ viewController: ViewController, shouldSegueWith thing: Any?) {    }
}

class SettingsViewController: ViewController {
    var delegate: ViewControllerDelegate?
}
