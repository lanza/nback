import Foundation
import CoreData

extension NSManagedObjectContext {
    public func save(errorHandler: ((Error) -> ())?) {
        do {
            try save()
        } catch {
            errorHandler?(error)
        }
    }
    
    
}
