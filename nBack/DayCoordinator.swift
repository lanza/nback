import UIKit

class DayCoordinator: NSObject, NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    let dayTableViewController = DayTableViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        dayTableViewController.delegate = self
    }
}

extension DayCoordinator: DayTableViewControllerDelegate {
    
}

