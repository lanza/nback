import UIKit
import CoreData

protocol DaysTableViewControllerDelegate: class {
  func didSelectDay(_ day: Day)
}

class DaysTableViewController: ViewController {
  weak var delegate: DaysTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
