import CoreData

public class GameResult: ManagedObject, Encodable {
  @NSManaged public var date: Date
  @NSManaged public var level: Int16
  @NSManaged public var numberOfTurns: Int16
  @NSManaged public var secondsBetweenTurns: Double
  @NSManaged public var rows: Int16
  @NSManaged public var columns: Int16
  @NSManaged public var squareHighlightTime: Double

  @NSManaged public var dayPlayed: Day?
  @NSManaged public var types: Set<TypeResult>

  private enum CodingKeys: String, CodingKey {
    case date
    case level
    case numberOfTurns
    case secondsBetweenTurns
    case rows
    case columns
    case squareHighlightTime
    case types
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(date, forKey: .date)
    try container.encode(level, forKey: .level)
    try container.encode(numberOfTurns, forKey: .numberOfTurns)
    try container.encode(secondsBetweenTurns, forKey: .secondsBetweenTurns)
    try container.encode(rows, forKey: .rows)
    try container.encode(columns, forKey: .columns)
    try container.encode(squareHighlightTime, forKey: .squareHighlightTime)
    try container.encode(types, forKey: .types)
  }

  var totalCorrect: Int {
    return Int(types.map { $0.correct }.reduce(0) { $0 + $1 })
  }

  var totalIncorrect: Int {
    return Int(types.map { $0.incorrect }.reduce(0) { $0 + $1 })
  }

  var percentage: String {
    return String(Double(totalCorrect) / Double(totalCorrect + totalIncorrect))
  }

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

// MARK: - For Tests

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
