import CoreData

extension GameResult {
    @NSManaged public var date: Date
    @NSManaged public var nBackLevel: Int16
    @NSManaged public var numberOfTurns: Int16
    @NSManaged public var secondsBetweenTurns: Int16
    @NSManaged public var backTypes: Set<BackTypeResult>
}
