import CoreData

class CoreData {
  static var shared: CoreData = {
    CoreData()
  }()

  private init() {}

  var context: NSManagedObjectContext {
    let vc = persistentContainer.viewContext
    vc.automaticallyMergesChangesFromParent = true
    return vc
  }

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentCloudKitContainer(name: "nBack")
    guard let description = container.persistentStoreDescriptions.first else {
      fatalError("Could not retrieve a persistent store description.")
    }
    //    let id = "iCloud.io.lanza.nBack-test"
    //    let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
    //    description.cloudKitContainerOptions = options
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
}
