import CoreData

public class Day: ManagedObject {
    
    @NSManaged public var date: Date
    @NSManaged public var day: Int16
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    
    @NSManaged public var results: Set<GameResult>!
    
    static func findOrCreateDay(in context: NSManagedObjectContext, for date: Date) -> Day {
        
        let components = Calendar.current.dateComponents([.day,.month,.year], from: date)
        guard let day = components.day, let month = components.month, let year = components.year else { fatalError() }
        let predicate = NSPredicate(format: "%K == %d AND %K == %d AND %K == %d", "day", day, "month", month, "year", year)
        return findOrCreate(in: context, matchingPredicate: predicate) { object in
            object.date = date
            object.day = Int16(day)
            object.month = Int16(month)
            object.year = Int16(year)
            object.results = Set<GameResult>()
        }
    }
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
