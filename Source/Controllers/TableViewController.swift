import CoreData
import UIKit

class TableViewController<Source: DataProvider, Object: ManagedObject, Cell: UITableViewCell>: UITableViewController, HasContext
    where Cell: ConfigurableCell, Cell.Object == Object, Object == Source.Object {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDataSource()
    }

    override func viewWillDisappear(_: Bool) {
        dataSource = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setDataProvider()
        setDataSource()
    }

    var dataSource: TableViewDataSource<Source, Cell>?
    var dataProvider: Source!

    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125
    }

    func setDataProvider() { fatalError() }
    func setDataSource() { dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider) }
}
