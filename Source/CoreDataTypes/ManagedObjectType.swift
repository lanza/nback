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
    
    public static func findOrCreate(in context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: ((Self) -> ()) ) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject = Self(context: context)
            configure(newObject)
            return newObject
        }
        return object
    }
    
    public static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializeObject(in: context, matchingPredicate: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }
    
    public static func materializeObject(in context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let res = object as? Self, predicate.evaluate(with: res) else { continue }
            return res
        }
        return nil
    }
    
    public static func fetch(in context: NSManagedObjectContext, configurationBlock: ((NSFetchRequest<Self>) -> ()) = { _ in }) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
}
