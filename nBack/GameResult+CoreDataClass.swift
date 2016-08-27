import CoreData

public class GameResult: ManagedObject {

    func initialize() {
        date = Date()
        nBackLevel = Int16(GameSettings.shared.level)
        numberOfTurns = Int16(GameSettings.shared.numberOfTurns)
        secondsBetweenTurns = Int16(GameSettings.shared.timeBetweenTurns)
        backTypes = Set<BackTypeResult>()
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
