import UIKit
import CoreData

class DaysTableViewController: UITableViewController, HasContext {
    
    var delegate: DaysTableViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Private
    
    typealias Source = FetchedResultsDataProvider<Day, DaysTableViewController>
    var dataSource: TableViewDataSource<Source, DaysTableViewCell>!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let request = Day.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 100
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "month", cacheName: "root")
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider)
    }


}

extension DaysTableViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Day>]?) {
        dataSource.process(updates: updates)
    }
}

protocol DaysTableViewControllerDelegate {
    func daysTableViewController(_ daysTableViewController: DaysTableViewController, didSelectDay: Day)
}
