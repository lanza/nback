import CoreData

public class GameResult: ManagedObject {
    
    @NSManaged public var date: Date
    @NSManaged public var level: Int16
    @NSManaged public var numberOfTurns: Int16
    @NSManaged public var secondsBetweenTurns: Double
    
    @NSManaged public var dayPlayed: Day?
    @NSManaged public var types: Set<TypeResult>
    
    func initialize() {
        guard let context = managedObjectContext else { fatalError() }
        date = Date()
        print("Hello")
        dayPlayed = Day.findOrCreateDay(in: context, for: date)
        level = Int16(GameSettings.shared.level)
        numberOfTurns = Int16(GameSettings.shared.numberOfTurns)
        secondsBetweenTurns = GameSettings.shared.secondsBetweenTurns
        types = Set<TypeResult>()
    }
    
}

extension GameResult: ManagedObjectType {
    public static var entityName: String {
        return "GameResult"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}
