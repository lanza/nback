import Foundation

protocol FetchedResultsDataProviderDelegate: AnyObject {
  associatedtype Object
  func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}
