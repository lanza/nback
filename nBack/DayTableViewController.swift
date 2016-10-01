import UIKit

class DayDataProvider: DataProvider {
    let day: Day
    let results: [GameResult]
    init(day: Day) {
        self.day = day
        self.results = Array(day.results).sorted { $0.date < $1.date }
    }
    
    func numberOfItemsIn(section: Int) -> Int {
        return results.count
    }
    func numberOfSections() -> Int {
        return 1
    }
    func object(at indexPath: IndexPath) -> GameResult {
        return results[indexPath.row]
    }
}



class DayTableViewController: TableViewController<DayDataProvider, GameResult, DayTableViewCell> {

    var day: Day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Lets.cellLabelDateFormatter.string(from: day.date)
    }
    
    override func setDataProvider() {
        dataProvider = DayDataProvider(day: day)
    }
    
    override func setupTableView() {
        
        // not sure why this doens't work
        
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 300
        
        
    }
    
    var delegate: DayTableViewControllerDelegate!
}


protocol DayTableViewControllerDelegate {
    
}
