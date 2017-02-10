import CoreData

public class ManagedObject: NSManagedObject {
    
}

import CoreData

public protocol ManagedObjectType: class, NSFetchRequestResult {
  static var entityName: String { get }
  static var defaultSortDescriptors: [NSSortDescriptor] { get }
  static var defaultPredicate: NSPredicate { get }
  var managedObjectContext: NSManagedObjectContext? { get }
}

extension ManagedObjectType {
  public static var request: NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: entityName)
    request.sortDescriptors = defaultSortDescriptors
    request.predicate = defaultPredicate
    return request
  }
  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return []
  }
  public static var defaultPredicate: NSPredicate {
    return NSPredicate(value: true)
  }
}

extension ManagedObjectType where Self: ManagedObject {
  
  public static func fetch(in context: NSManagedObjectContext, configurationBlock: ((NSFetchRequest<Self>) -> ()) = { _ in }) -> [Self] {
    let request = NSFetchRequest<Self>(entityName: Self.entityName)
    configurationBlock(request)
    return try! context.fetch(request)
  }
}
