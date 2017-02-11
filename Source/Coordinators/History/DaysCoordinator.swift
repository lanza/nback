import UIKit
import CoordinatorKit
import RxCocoa
import RxSwift

class DaysCoordinator: Coordinator {
  
  var daysTableViewController: DaysTableViewController { return viewController as! DaysTableViewController }
  
  override func loadViewController() {
    viewController = DaysTableViewController()
    daysTableViewController.delegate = self
    
    daysTableViewController.title = Lets.historyl10n
    daysTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
    daysTableViewController.tabBarItem.title = Lets.historyl10n
    
  }
}

extension DaysCoordinator: DaysTableViewControllerDelegate {
  func didSelectDay(_ day: Day) {
    let dayCoordinator = DayCoordinator()
    dayCoordinator.day = day
    self.show(dayCoordinator, sender: self)
  }
}
