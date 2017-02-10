import UIKit
import CoordinatorKit

class AppCoordinator: TabBarCoordinator {
  
  override func viewControllerDidLoad() {
    super.viewControllerDidLoad()
        Theme.setupAppearances()
        setCoordinators(createTabs(), animated: false)
    }
    
    private func createTabs() -> [Coordinator] {
        let playCoordinator = PlayCoordinator()
        let playNav = NavigationCoordinator(rootCoordinator: playCoordinator)
        
        let daysCoordinator = DaysCoordinator()
        let historyNav = NavigationCoordinator(rootCoordinator: daysCoordinator)
        
        //NYI
//        let settingsCoordinator = SettingsCoordinator()
//        settingsCoordinator.start()
//        settingsCoordinator.delegate = self
//        let settingsNav = NavigationController(viewController: settingsCoordinator.settingsViewController)
//        coordinators.append(settingsCoordinator)
        
        return [playNav,historyNav]
    }
    
}
