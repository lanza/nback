import CoreData

class CoreData {
    
    static var shared: CoreData = {
        return CoreData()
    }()
    
    private init() { }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "nBack")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        }
        return container
    }()
}
