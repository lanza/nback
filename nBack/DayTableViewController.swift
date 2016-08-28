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
    
    override func setDataProvider() {
        dataProvider = DayDataProvider(day: day)
    }
    
    
    var delegate: DayTableViewControllerDelegate!
}


protocol DayTableViewControllerDelegate {
    
}
