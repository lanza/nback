import CoreData

protocol DataProvider: class {
    associatedtype Object
    func object(at indexPath: IndexPath) -> Object
    func numberOfItemsIn(section: Int) -> Int
    func numberOfSections() -> Int
}

protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<Object> {
    case insert(IndexPath)
    case update(IndexPath, Object)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}
import UIKit
class TableViewCell: UITableViewCell, ConfigurableCell {
    func configure(for object: GameResult) {
        textLabel?.text = "\(object.date)"
    }
}
protocol ConfigurableCell {
    associatedtype Object
    func configure(for object: Object)
}
class TableViewDataSource<Source: DataProvider, Cell: TableViewCell>: NSObject, UITableViewDataSource where Cell: ConfigurableCell, Cell.Object == Source.Object {
    
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

class FetchedResultsDataProvider<Object: ManagedObject, Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider where Object == Delegate.Object {
    
    init(fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    func reconfigureFetchRequest(block: (NSFetchRequest<Object>) -> ()) {
        NSFetchedResultsController<Object>.deleteCache(withName: fetchedResultsController.cacheName)
        block(fetchedResultsController.fetchRequest)
        do { try fetchedResultsController.performFetch() } catch { fatalError() }
        delegate.dataProviderDidUpdate(updates: nil)
    }
    
    func object(at indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func numberOfSections() -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func numberOfItemsIn(section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    // MARK: Private
    
    private let fetchedResultsController: NSFetchedResultsController<Object>
    private weak var delegate: Delegate!
    private var updates = [DataProviderUpdate<Object>]()
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            let object = self.object(at: indexPath)
            updates.append(.update(indexPath, object))
        case .move:
            guard let indexPath = indexPath else { fatalError() }
            guard let newIndexPath = newIndexPath else { fatalError() }
            updates.append(.move(indexPath,newIndexPath))
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            updates.append(.delete(indexPath))
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.dataProviderDidUpdate(updates: updates)
    }
}
