import UIKit
import CoreData

class DaysTableViewController: TableViewController<FetchedResultsDataProvider<Day>,Day,DaysTableViewCell> {
    
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
    var delegate: DaysTableViewControllerDelegate?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let day = dataSource?.selectedObject else { fatalError() }
        delegate?.daysTableViewController(self, didSelect: day)
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Theme.Colors.background.color
    }
}

protocol DaysTableViewControllerDelegate {
    func daysTableViewController(_ daysTableViewController: DaysTableViewController, didSelect day: Day)
}

