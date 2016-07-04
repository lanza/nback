import Foundation
import CoreData

extension BackTypeResult {

    @NSManaged var backType: NSNumber?
    @NSManaged var correct: NSNumber? // true true
    @NSManaged var incorrect: NSNumber? // false true
    @NSManaged var matches: NSNumber? // true x
    @NSManaged var game: GameResult?

}
