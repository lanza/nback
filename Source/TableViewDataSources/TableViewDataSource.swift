import UIKit

class DaysTableViewDataSource: TableViewDataSource<FetchedResultsDataProvider<Day>, DaysTableViewCell> {
    
  //  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   //     let object = dataProvider.object(at: IndexPath(row: 0, section: section))
    //    return Lets.headerDateFormatter.string(from: object.date)
 //   }
    
}

class DayTableViewDataSource: TableViewDataSource<DayDataProvider, GameResultCell> {
    
}

class TableViewDataSource<Source: DataProvider, Cell: UITableViewCell>: NSObject, UITableViewDataSource where Cell: ConfigurableCell, Cell.Object == Source.Object {
    
    required init(tableView: UITableView, dataProvider: Source) {
        self.tableView = tableView
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
                cell.configure(for: object, indexPath: indexPath)
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
    
    let tableView: UITableView
    let dataProvider: Source
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSections()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsIn(section: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Lets.cellIdentifier, for: indexPath) as? Cell else { fatalError() }
        cell.configure(for: object, indexPath: indexPath)
        return cell
    }
}
