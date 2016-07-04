import Foundation
import CoreData

extension GameResult {

    @NSManaged var date: Date!  
    @NSManaged var nbackLevel: NSNumber!
    @NSManaged var numberOfTurns: NSNumber!
    @NSManaged var secondsBetweenTurns: NSNumber!
    @NSManaged var backTypes: Set<BackTypeResult>!

}
