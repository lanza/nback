import UIKit

class DayDataProvider: DataProvider {
    let day: Day
    let results: [GameResult]
    init(day: Day) {
        self.day = day
        results = Array(day.results).sorted { $0.date < $1.date }
    }

    func numberOfItemsIn(section _: Int) -> Int {
        return results.count
    }

    func numberOfSections() -> Int {
        return 1
    }

    func object(at indexPath: IndexPath) -> GameResult {
        return results[indexPath.row]
    }
}

class DayTableViewController: TableViewController<DayDataProvider, GameResult, GameResultCell> {
    var day: Day!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Lets.cellLabelDateFormatter.string(from: day.date)
        let nib = UINib(nibName: "GameResultCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }

    override func setDataProvider() {
        dataProvider = DayDataProvider(day: day)
    }

    override func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }
}
