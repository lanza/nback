import UIKit
import CoreData

class TableViewController<Source: DataProvider, Object: ManagedObject, Cell: UITableViewCell>: UITableViewController, HasContext
where Cell: ConfigurableCell, Cell.Object == Object, Object == Source.Object {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource()
    }
    override func viewWillDisappear(_ animated: Bool) {
        dataSource = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    var dataSource: TableViewDataSource<Source, Cell>?
    var dataProvider: Source!
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        setDataProvider()
        setDataSource()
    }
    
    func setDataProvider() { fatalError() }
    func setDataSource() { dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider) }
}
