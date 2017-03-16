import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol DaysTableViewControllerDelegate: class {
    func didSelectDay(_ day: Day)
}

class DaysTableViewController: ViewController {
    weak var delegate: DaysTableViewControllerDelegate!
    
   
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


enum HistorySectionModel {
    case month(monthInfo: MonthInfo)
}
extension HistorySectionModel: AnimatableSectionModelType {
    var identity: YearMonth {
        switch self {
        case .month(monthInfo: let monthInfo): return YearMonth(year: monthInfo.year, month: monthInfo.month)
        }
    }
    typealias Item = DayInfo
    var items: [DayInfo] {
        switch self {
        case .month(monthInfo: let monthInfo):
            return monthInfo.dayInfoDict.values.sorted { $0.day > $1.day }
        }
    }
    init(original: HistorySectionModel, items: [DayInfo]) {
        switch original {
        case .month(monthInfo: let monthInfo):
            var newMonthInfo = MonthInfo(year: monthInfo.year, month: monthInfo.month)
            var dayInfoDict: [Int:DayInfo] = [:]
            for dayInfo in items {
                dayInfoDict[dayInfo.day] = dayInfo
            }
            newMonthInfo.dayInfoDict = dayInfoDict
            self = .month(monthInfo: newMonthInfo)
        }
    }
}
