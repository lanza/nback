import Foundation

protocol DataProvider: class {
    associatedtype Object
    func object(at indexPath: IndexPath) -> Object
    func numberOfItemsIn(section: Int) -> Int
    func numberOfSections() -> Int
}
