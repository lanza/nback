import CoordinatorKit
import UIKit

class DayCoordinator: Coordinator {
    var dayTableViewController: DayTableViewController { return viewController as! DayTableViewController }

    var day: Day!

    override func loadViewController() {
        viewController = DayTableViewController()
        dayTableViewController.day = day
    }
}
