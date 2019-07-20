import CoreData
import UIKit

protocol HasWindow {}
extension HasWindow {
    var window: UIWindow {
        return (UIApplication.shared.delegate as! AppDelegate).window!
    }

    static var window: UIWindow {
        return (UIApplication.shared.delegate as! AppDelegate).window!
    }
}

public protocol HasContext {}
extension HasContext {
    public var context: NSManagedObjectContext { return CoreData.shared.context }
}
