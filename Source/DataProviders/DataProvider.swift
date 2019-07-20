import Foundation

protocol DataProvider: AnyObject {
    associatedtype Object
    func object(at indexPath: IndexPath) -> Object
    func numberOfItemsIn(section: Int) -> Int
    func numberOfSections() -> Int
}
