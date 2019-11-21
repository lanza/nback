import CoreData

extension NSManagedObjectContext {
  public func save(errorHandler: ((Error) -> Void)?) {
    do {
      try save()
    } catch {
      errorHandler?(error)
    }
  }
}
