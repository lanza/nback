import CoreData

public class TypeResult: ManagedObject, Encodable {
  @NSManaged public var falseFalse: Int16
  @NSManaged public var falseTrue: Int16
  @NSManaged public var trueFalse: Int16
  @NSManaged public var trueTrue: Int16

  @NSManaged public var matches: Int16
  @NSManaged public var incorrect: Int16
  @NSManaged public var correct: Int16
  @NSManaged private var ttype: Int16
  @NSManaged public var game: GameResult?

  private enum CodingKeys: String, CodingKey {
    case falseFalse
    case falseTrue
    case trueFalse
    case trueTrue
    case matches
    case incorrect
    case correct
    case ttype
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(falseFalse, forKey: .falseFalse)
    try container.encode(falseTrue, forKey: .falseTrue)
    try container.encode(trueFalse, forKey: .trueFalse)
    try container.encode(trueTrue, forKey: .trueTrue)
    try container.encode(matches, forKey: .matches)
    try container.encode(incorrect, forKey: .incorrect)
    try container.encode(correct, forKey: .correct)
    try container.encode(ttype, forKey: .ttype)
  }

  public var type: GameType {
    get { return GameType.from(value: Int(ttype)) }
    set { ttype = Int16(newValue.value) }
  }
}

extension TypeResult: ManagedObjectType {
  public static var entityName: String {
    return "TypeResult"
  }

  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: "matches", ascending: false)]
  }
}
