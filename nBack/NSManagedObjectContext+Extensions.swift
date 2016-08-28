import CoreData

extension NSManagedObjectContext {
    func save(errorHandler: ((Error) -> ())?) {
        do {
            try save()
        } catch {
            errorHandler?(error)
        }
    }
    

}
