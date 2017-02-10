import UIKit
import CoordinatorKit
import RxCocoa
import RxSwift

class DaysCoordinator: Coordinator {
    
    var daysTableViewController: DaysTableViewController { return viewController as! DaysTableViewController }
    
    override func loadViewController() {
        viewController = DaysTableViewController()
        daysTableViewController.title = Lets.historyl10n
        daysTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        daysTableViewController.tabBarItem.title = Lets.historyl10n
        
        daysTableViewController.didSelectDay = { day in
            let dayCoordinator = DayCoordinator()
            dayCoordinator.day = day
            self.show(dayCoordinator, sender: self)
        }
    }
    
}


