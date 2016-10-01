import CoreData

public class GameResult: ManagedObject {
    
    @NSManaged public var date: Date
    @NSManaged public var level: Int16
    @NSManaged public var numberOfTurns: Int16
    @NSManaged public var secondsBetweenTurns: Double
    @NSManaged public var rows: Int16
    @NSManaged public var columns: Int16
    @NSManaged public var squareHighlightTime: Double
    
    @NSManaged public var dayPlayed: Day?
    @NSManaged public var types: Set<TypeResult>
    
    public func initialize() {
        guard let context = managedObjectContext else { fatalError() }
        date = Date()
        
        dayPlayed = Day.findOrCreateDay(in: context, for: date)
        level = Int16(GameSettings.shared.level)
        numberOfTurns = Int16(GameSettings.shared.numberOfTurns)
        secondsBetweenTurns = GameSettings.shared.secondsBetweenTurns
        rows = Int16(GameSettings.shared.rows)
        columns = Int16(GameSettings.shared.columns)
        squareHighlightTime = GameSettings.shared.squareHighlightTime
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

//MARK: - For Tests
extension GameResult {
    public func initialize(with date: Date) {
        guard let context = managedObjectContext else { fatalError() }
        self.date = date
        dayPlayed = Day.findOrCreateDay(in: context, for: date)
        level = Int16(GameSettings.shared.level)
        numberOfTurns = Int16(GameSettings.shared.numberOfTurns)
        secondsBetweenTurns = GameSettings.shared.secondsBetweenTurns
        types = Set<TypeResult>()
    }
}
