import UIKit
import CoreData

class DaysTableViewController: TableViewController<FetchedResultsDataProvider<Day>,Day,DaysTableViewCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DaysTableViewCell.self, forCellReuseIdentifier: Lets.cellIdentifier)
    }
    override func setDataProvider() {
        let request = Day.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
        dataProvider = FetchedResultsDataProvider<Day>(fetchedResultsController: frc)
    }
    override func setDataSource() {
        dataSource = DaysTableViewDataSource(tableView: tableView, dataProvider: dataProvider)
    }
    
    override var dataSource: TableViewDataSource<FetchedResultsDataProvider<Day>, DaysTableViewCell>? {
        didSet {
            let dataProviderDelegate = AnyDataProviderDelegate<Day>()
            dataProviderDelegate.dataProviderDidUpdate = dataSource?.process
            dataProvider.delegate = dataProviderDelegate
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let day = dataSource?.selectedObject else { fatalError() }
        didSelectDay(day)
    }
    var didSelectDay: ((Day) -> ())!
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Theme.Colors.background
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35   
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! HeaderView
        let object = dataProvider.object(at: IndexPath(row: 0, section: section))
        header.dateLabel.text = Lets.headerDateFormatter.string(from: object.date)
        return header
    }
}
