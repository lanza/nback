import CoreData

public class Day: ManagedObject {
    
    @NSManaged public var date: Date
    @NSManaged public var day: Int16
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    
    @NSManaged public var results: Set<GameResult>!
    
    var si = "sectionIdentifier"
    var sectionIdentifier: String? {
        self.willAccessValue(forKey: si)
        var tmp = self.primitiveValue(forKey: si) as? String
        self.didAccessValue(forKey: si)
        
        if tmp == nil {
            let year = self.value(forKey: "year") as! Int
            let month = self.value(forKey: "month") as! Int
            tmp = "\(year * 1000 + month)"
            self.setPrimitiveValue(tmp, forKey: si)
        }
        return tmp
    }
}

extension Day: ManagedObjectType {
    public static var entityName: String {
        return "Day"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "year", ascending: true), NSSortDescriptor(key: "month", ascending: true), NSSortDescriptor(key: "day", ascending: true)]
    }
}
