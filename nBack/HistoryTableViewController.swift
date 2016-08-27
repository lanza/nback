import UIKit
import CoreData

class HistoryTableViewController: UITableViewController, HasContext {
    
    var delegate: HistoryTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: Private
    
    typealias Source = FetchedResultsDataProvider<GameResult, HistoryTableViewController>
    var dataSource: TableViewDataSource<Source, TableViewCell>!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let request = GameResult.request
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 100
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider)
    }


}

extension HistoryTableViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<GameResult>]?) {
        dataSource.process(updates: updates)
    }
}

protocol HistoryTableViewControllerDelegate {
    
}
