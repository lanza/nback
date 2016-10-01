import UIKit

class AppCoordinator: NSObject, NBCoordinator {
    
    weak var delegate: CoordinatorDelegate! = nil
    
    let tabBarController = UITabBarController()
    var coordinators = [NBCoordinator]()
    
    override init() {
        super.init()
    }
    
    func start() {
        Theme.setupAppearances()
        tabBarController.viewControllers = createTabVCs()
        window.rootViewController = tabBarController
    }
    
    private func createTabVCs() -> [UIViewController] {
        let playCoordinator = PlayCoordinator()
        playCoordinator.start()
        playCoordinator.delegate = self
        let playNav = NavigationController(viewController: playCoordinator.playViewController)
        coordinators.append(playCoordinator)
        
        let daysCoordinator = DaysCoordinator()
        daysCoordinator.start()
        daysCoordinator.delegate = self
        let historyNav = NavigationController(viewController: daysCoordinator.daysTableViewController)
        coordinators.append(daysCoordinator)
        
        //NYI
//        let settingsCoordinator = SettingsCoordinator()
//        settingsCoordinator.start()
//        settingsCoordinator.delegate = self
//        let settingsNav = NavigationController(viewController: settingsCoordinator.settingsViewController)
//        coordinators.append(settingsCoordinator)
        
        return [playNav,historyNav]
    }
    
}

extension AppCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

extension AppCoordinator: CoordinatorDelegate { }
