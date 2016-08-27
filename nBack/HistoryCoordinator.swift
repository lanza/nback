import UIKit

class HistoryCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    var historyTableViewController = HistoryTableViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        historyTableViewController.delegate = self
        historyTableViewController.title = Lets.historyl10n
        historyTableViewController.tabBarItem.title = Lets.historyl10n
        historyTableViewController.tabBarItem.image = nil
    }
    
}

extension HistoryCoordinator: HistoryTableViewControllerDelegate {
    
}

extension HistoryCoordinator: CoordinatorDelegate { }
