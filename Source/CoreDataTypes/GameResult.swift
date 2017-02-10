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
    
    var totalCorrect: Int { return Int(types.map { return $0.correct }.reduce(0) { $0 + $1 }) }
    var totalIncorrect: Int { return Int(types.map { $0.incorrect }.reduce(0) { $0 + $1 }) }
    var percentage: String { return String(Double(totalCorrect) / (Double(totalCorrect + totalIncorrect))) }
    
    public func initialize() {
        guard let context = managedObjectContext else { fatalError() }
        date = Date()
        
        dayPlayed = Day.findOrCreateDay(in: context, for: date)
        level = Int16(GameSettings.level)
        numberOfTurns = Int16(GameSettings.numberOfTurns)
        secondsBetweenTurns = GameSettings.secondsBetweenTurns
        rows = Int16(GameSettings.rows)
        columns = Int16(GameSettings.columns)
        squareHighlightTime = GameSettings.squareHighlightTime
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
        level = Int16(GameSettings.level)
        numberOfTurns = Int16(GameSettings.numberOfTurns)
        secondsBetweenTurns = GameSettings.secondsBetweenTurns
        types = Set<TypeResult>()
    }
}

import RealmSwift

class GameResultRealm: Object {
  
  dynamic var columns = 0
  dynamic var rows = 0
  
  dynamic var date = Date()
  
  dynamic var level = 0
  dynamic var numberOfTurns = 0
  dynamic var secondsBetweenTurns = 0
  dynamic var squareHighlightTime = 0
  
  let types = LinkingObjects(fromType: TypeResultRealm.self, property: "game")
}

class TypeResultRealm: Object {
  
  dynamic var correct = 0
  dynamic var incorrect = 0
  
  dynamic var matches = 0
  
  dynamic var falseFalse = 0
  dynamic var falseTrue = 0
  dynamic var trueFalse = 0
  dynamic var trueTrue = 0
  
  dynamic var nBackTypeInt = 0
 
  var nBackType: NBackType { return NBackType(rawValue: nBackTypeInt)! }
  
  enum NBackType: Int {
    case squares = 0
    case numbers = 1
    case colors = 2
  }
  
  dynamic var game: GameResultRealm?
}









