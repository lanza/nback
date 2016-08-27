import CoreData

extension BackTypeResult {
    @NSManaged public var matches: Int64
    @NSManaged public var incorrect: Int64
    @NSManaged public var correct: Int64
    @NSManaged public var backType: Int64
    @NSManaged public var game: GameResult
}
