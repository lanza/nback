import UIKit

class HistoryCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    var daysTableViewController = DaysTableViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        daysTableViewController.delegate = self
        daysTableViewController.title = Lets.historyl10n
        daysTableViewController.tabBarItem.title = Lets.historyl10n
        daysTableViewController.tabBarItem.image = nil
    }
}

extension HistoryCoordinator: DaysTableViewControllerDelegate {
    func daysTableViewController(_ daysTableViewController: DaysTableViewController, didSelect day: Day) {
        let dayCoordinator = DayCoordinator()
        dayCoordinator.dayTableViewController.day = day
        dayCoordinator.delegate = self
        coordinators.append(dayCoordinator)
        dayCoordinator.start()
        daysTableViewController.navigationController?.pushViewController(dayCoordinator.dayTableViewController, animated: true)
    }
}

extension HistoryCoordinator: CoordinatorDelegate { }
