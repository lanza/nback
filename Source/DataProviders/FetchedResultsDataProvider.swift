import CoreData
import UIKit

// class HistoryByDateFetchedResultsDataProvider: FetchedResultsDataProvider<GameResult, TableViewController> {
//
//    var dateCountPairs = [(Date,Int)]()
//
//    override init(fetchedResultsController: NSFetchedResultsController<GameResult>, delegate: TableViewController) {
//        super.init(fetchedResultsController: fetchedResultsController, delegate: delegate)
//
//        generateDateCountPairs()
//    }
//
//    private func generateDateCountPairs() {
//        var dateCountDict = [Date:Int]()
//        fetchedResultsController.fetchedObjects?.forEach { dateCountDict[$0.date] = (dateCountDict[$0.date] ?? 0) + 1 }
//        dateCountPairs = dateCountDict.map { ($0,$1) }
//    }
//
//    override func object(at indexPath: IndexPath) -> GameResult {
//        fatalError()
//    }
// }

class AnyDataProviderDelegate<Object: ManagedObject>: FetchedResultsDataProviderDelegate
{
  var dataProviderDidUpdate: (([DataProviderUpdate<Object>]?) -> Void)?

  func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?) {
    dataProviderDidUpdate?(updates)
  }
}

class FetchedResultsDataProvider<Object: ManagedObject>: NSObject,
  NSFetchedResultsControllerDelegate, DataProvider
{
  init(fetchedResultsController: NSFetchedResultsController<Object>) {
    self.fetchedResultsController = fetchedResultsController
    super.init()
    fetchedResultsController.delegate = self
    try! fetchedResultsController.performFetch()

    let sections = fetchedResultsController.sections!
    for section in sections {
      print("new section")
      for item in section.objects as! [Day] {
        print(item.year, item.month, item.day)
      }
    }
  }

  func reconfigureFetchRequest(block: (NSFetchRequest<Object>) -> Void) {
    NSFetchedResultsController<Object>.deleteCache(
      withName: fetchedResultsController.cacheName
    )
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
    guard let section = fetchedResultsController.sections?[section] else {
      return 0
    }
    return section.numberOfObjects
  }

  // MARK: Private

  let fetchedResultsController: NSFetchedResultsController<Object>

  weak var delegate: AnyDataProviderDelegate<Object>!
  private var updates = [DataProviderUpdate<Object>]()

  // MARK: NSFetchedResultsControllerDelegate

  func controllerWillChangeContent(
    _: NSFetchedResultsController<NSFetchRequestResult>
  ) {
    updates = []
  }

  func controller(
    _: NSFetchedResultsController<NSFetchRequestResult>,
    didChange _: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?
  ) {
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
      updates.append(.move(indexPath, newIndexPath))
    case .delete:
      guard let indexPath = indexPath else { fatalError() }
      updates.append(.delete(indexPath))
    @unknown default:
      fatalError("Fix this")
    }
  }

  func controllerDidChangeContent(
    _: NSFetchedResultsController<NSFetchRequestResult>
  ) {
    delegate?.dataProviderDidUpdate(updates: updates)
  }
}
