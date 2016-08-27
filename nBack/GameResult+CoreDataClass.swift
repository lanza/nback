import CoreData

public class GameResult: ManagedObject {

}

extension GameResult: ManagedObjectType {
    public static var entityName: String {
        return "GameResult"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}
