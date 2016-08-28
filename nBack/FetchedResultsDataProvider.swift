    import CoreData

import UIKit

class TableViewController: UITableViewController, DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<GameResult>]?) {
        //
    }
}

class HistoryByDateFetchedResultsDataProvider: FetchedResultsDataProvider<GameResult, TableViewController> {
    
    var dateCountPairs = [(Date,Int)]()
    
    override init(fetchedResultsController: NSFetchedResultsController<GameResult>, delegate: TableViewController) {
        super.init(fetchedResultsController: fetchedResultsController, delegate: delegate)
        
        generateDateCountPairs()
    }
    
    private func generateDateCountPairs() {
        var dateCountDict = [Date:Int]()
        fetchedResultsController.fetchedObjects?.forEach { dateCountDict[$0.date] = (dateCountDict[$0.date] ?? 0) + 1 }
        dateCountPairs = dateCountDict.map { ($0,$1) }
    }
    
    override func object(at indexPath: IndexPath) -> GameResult {
        fatalError()
    }
}

class FetchedResultsDataProvider<Object: ManagedObject, Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider where Object == Delegate.Object {
    
    init(fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        print(fetchedResultsController.sections, fetchedResultsController.sectionNameKeyPath)
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
    
    let fetchedResultsController: NSFetchedResultsController<Object>
    private weak var delegate: Delegate!
    private var updates = [DataProviderUpdate<Object>]()
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates.removeAll()
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
