import CoreData

public class GameResult: ManagedObject {
  
  @NSManaged public var date: Date
  
  @NSManaged public var rows: Int16
  @NSManaged public var columns: Int16
  
  @NSManaged public var level: Int16
  @NSManaged public var numberOfTurns: Int16
  @NSManaged public var secondsBetweenTurns: Double
  @NSManaged public var squareHighlightTime: Double
  
  @NSManaged public var types: Set<TypeResult>
  
  var totalCorrect: Int { return Int(types.map { return $0.correct }.reduce(0) { $0 + $1 }) }
  var totalIncorrect: Int { return Int(types.map { $0.incorrect }.reduce(0) { $0 + $1 }) }
  var percentage: String { return String(Double(totalCorrect) / (Double(totalCorrect + totalIncorrect))) }
  
  @NSManaged public var dayPlayed: Day?
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
    dayPlayed = Day(context: context)
    level = Int16(GameSettings.level)
    numberOfTurns = Int16(GameSettings.numberOfTurns)
    secondsBetweenTurns = GameSettings.secondsBetweenTurns
    types = Set<TypeResult>()
  }
}













