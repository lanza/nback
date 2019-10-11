import CoreData

public final class ManagedObjectObserver {
  public enum ChangeType {
    case delete
    case update
  }

  public init?(
    object: ManagedObjectType,
    changeHandler: @escaping ((ChangeType) -> Void)
  ) {
    guard let moc = object.managedObjectContext else { return nil }
    objectHasBeenDeleted = !type(of: object).defaultPredicate.evaluate(
      with: object
    )
    token = moc.addObjectsDidChangeNotificationObserver { [unowned self] note in
      guard
        let changeType = self.changeTypeOfObject(
          object: object,
          inNotification: note
        )
      else { return }
      self.objectHasBeenDeleted = changeType == .delete
      changeHandler(changeType)
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(token!)
  }

  // MARK: Private

  private var token: NSObjectProtocol!

  private var objectHasBeenDeleted = false

  private func changeTypeOfObject(
    object: ManagedObjectType,
    inNotification note: ObjectsDidChangeNotification
  ) -> ChangeType? {
    let deleted = note.deletedObjects.union(note.invalidatedObjects)
    if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object)
    {
      return .delete
    }
    let updated = note.updatedObjects.union(note.refreshedObjects)
    if updated.containsObjectIdentical(to: object) {
      let predicate = type(of: object).defaultPredicate
      if predicate.evaluate(with: object) {
        return .update
      }
      else if objectHasBeenDeleted == false {
        return .delete
      }
    }
    return nil
  }
}

public struct ObjectsDidChangeNotification {
  init(note: Notification) {
    assert(
      note.name == Notification.Name.NSManagedObjectContextObjectsDidChange
    )
    notification = note
  }

  public var insertedObjects: Set<ManagedObject> {
    return objectsFor(key: NSInsertedObjectsKey)
  }

  public var updatedObjects: Set<ManagedObject> {
    return objectsFor(key: NSUpdatedObjectsKey)
  }

  public var deletedObjects: Set<ManagedObject> {
    return objectsFor(key: NSDeletedObjectsKey)
  }

  public var refreshedObjects: Set<ManagedObject> {
    return objectsFor(key: NSRefreshedObjectsKey)
  }

  public var invalidatedObjects: Set<ManagedObject> {
    return objectsFor(key: NSInvalidatedObjectsKey)
  }

  public var invalidatedAllObjects: Bool {
    return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
  }

  public var managedObjectContext: NSManagedObjectContext {
    guard let context = notification.object as? NSManagedObjectContext else {
      fatalError()
    }
    return context
  }

  // MARK: Private

  private let notification: Notification

  private func objectsFor(key: String) -> Set<ManagedObject> {
    return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
  }
}

extension NSManagedObjectContext {
  public func addObjectsDidChangeNotificationObserver(
    handler: @escaping ((ObjectsDidChangeNotification) -> Void)
  ) -> NSObjectProtocol {
    return NotificationCenter.default.addObserver(
      forName: .NSManagedObjectContextObjectsDidChange,
      object: self,
      queue: nil
    ) { note in
      let wrappedNote = ObjectsDidChangeNotification(note: note)
      handler(wrappedNote)
    }
  }
}
