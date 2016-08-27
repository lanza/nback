import CoreData

extension BackTypeResult {
    @NSManaged public var matches: Int16
    @NSManaged public var incorrect: Int16
    @NSManaged public var correct: Int16
    @NSManaged public var backType: Int16
    @NSManaged public var game: GameResult
}
