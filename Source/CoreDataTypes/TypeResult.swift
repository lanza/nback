import CoreData

public class TypeResult: ManagedObject {
    
    @NSManaged public var falseFalse: Int16
    @NSManaged public var falseTrue: Int16
    @NSManaged public var trueFalse: Int16
    @NSManaged public var trueTrue: Int16
    
    @NSManaged public var matches: Int16
    @NSManaged public var incorrect: Int16
    @NSManaged public var correct: Int16
    @NSManaged private var ttype: Int16
    @NSManaged public var game: GameResult
    
    public var type: NBackType {
        get { return NBackType.from(value: Int(ttype)) }
        set { ttype = Int16(newValue.value) }
    }
}
