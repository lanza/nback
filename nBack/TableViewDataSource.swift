import UIKit

class DaysByDateTableViewDataSource: TableViewDataSource<FetchedResultsDataProvider<Day, DaysTableViewController>, DaysTableViewCell> {
    override func process(updates: [DataProviderUpdate<Day>]?) {
        //
    }
    
    required init(tableView: UITableView, dataProvider: FetchedResultsDataProvider<Day, DaysTableViewController>) {
        super.init(tableView: tableView, dataProvider: dataProvider)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        fatalError()
    }
}

class TableViewDataSource<Source: DataProvider, Cell: TableViewCell>: NSObject, UITableViewDataSource where Cell: ConfigurableCell, Cell.Object == Source.Object {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header"
    }
    
    required init(tableView: UITableView, dataProvider: Source) {
        self.tableView = tableView
        tableView.register(Cell.self, forCellReuseIdentifier: Lets.cellIdentifier)
        self.dataProvider = dataProvider
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    var selectedObject: Source.Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return dataProvider.object(at: indexPath)
    }
    
    func process(updates: [DataProviderUpdate<Source.Object>]?) {
        
        guard let updates = updates else { return tableView.reloadData() }
        
        tableView.beginUpdates()
        
        for update in updates {
            
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .automatic)
            case .update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else { break }
                cell.configure(for: object)
            case .move(let indexPath, let newIndexPath):
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
        tableView.endUpdates()
    }    
    
    // MARK: Private
    
    private let tableView: UITableView
    private let dataProvider: Source
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsIn(section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        let identifier = Lets.cellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else { fatalError() }
        cell.configure(for: object)
        return cell
    }
}
