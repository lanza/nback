import UIKit
import CoordinatorKit

class AppCoordinator: TabBarCoordinator {
    
    override func start() {
        super.start()
        Theme.setupAppearances()
        setCoordinators(createTabs(), animated: false)
    }
    
    private func createTabs() -> [Coordinator] {
        let playCoordinator = PlayCoordinator()
        playCoordinator.start()
        let playNav = NavigationCoordinator(rootCoordinator: playCoordinator)
        playNav.start()
        
        let daysCoordinator = DaysCoordinator()
        daysCoordinator.start()
        let historyNav = NavigationCoordinator(rootCoordinator: daysCoordinator)
        historyNav.start()
        
        //NYI
//        let settingsCoordinator = SettingsCoordinator()
//        settingsCoordinator.start()
//        settingsCoordinator.delegate = self
//        let settingsNav = NavigationController(viewController: settingsCoordinator.settingsViewController)
//        coordinators.append(settingsCoordinator)
        
        return [playNav,historyNav]
    }
    
}
