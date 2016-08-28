import UIKit

class HistoryCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    var historyTableViewController = DaysTableViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        historyTableViewController.delegate = self
        historyTableViewController.title = Lets.historyl10n
        historyTableViewController.tabBarItem.title = Lets.historyl10n
        historyTableViewController.tabBarItem.image = nil
    }
    
}

extension HistoryCoordinator: DaysTableViewControllerDelegate {
    func daysTableViewController(_ daysTableViewController: DaysTableViewController, didSelectDay: Day) {
        // do navigation
    }
}

extension HistoryCoordinator: CoordinatorDelegate { }
