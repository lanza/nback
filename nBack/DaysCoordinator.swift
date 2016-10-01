import UIKit

class DaysCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    var daysTableViewController = DaysTableViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        daysTableViewController.delegate = self
        daysTableViewController.title = Lets.historyl10n
        daysTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        daysTableViewController.tabBarItem.title = Lets.historyl10n        
    }
}

extension DaysCoordinator: DaysTableViewControllerDelegate {
    func daysTableViewController(_ daysTableViewController: DaysTableViewController, didSelect day: Day) {
        let dayCoordinator = DayCoordinator()
        dayCoordinator.dayTableViewController.day = day
        dayCoordinator.delegate = self
        coordinators.append(dayCoordinator)
        dayCoordinator.start()
        daysTableViewController.navigationController?.pushViewController(dayCoordinator.dayTableViewController, animated: true)
    }
}

extension DaysCoordinator: CoordinatorDelegate { }
