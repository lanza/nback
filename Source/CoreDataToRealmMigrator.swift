import CoreData
import Foundation

final class CoreDataToRealmMigrator {
    static func fetchAllCoreDataGameResults() -> [GameResult] {
        return GameResult.fetch(in: CoreData.shared.context)
    }
    
    static func convertData() {
        
        let gameResults =  GameResult.fetch(in: CoreData.shared.context)
        
        for result in gameResults {
            let gameResultRealm = GameResultRealm.new(columns: Int(result.columns), rows: Int(result.rows), level: Int(result.level), numberOfTurns: Int(result.numberOfTurns), secondsBetweenTurns: result.secondsBetweenTurns, squareHighlightTime: result.squareHighlightTime)
            for typeResult in result.types {
                let score = Score(falseFalse: Int(typeResult.falseFalse), falseTrue: Int(typeResult.falseTrue), trueFalse: Int(typeResult.trueFalse), trueTrue: Int(typeResult.trueTrue))
                let typeResultRealm = TypeResultRealm.new(score: score, nBackType: typeResult.type)
                gameResultRealm.add(typeResult: typeResultRealm)
            }
        }
        
        deleteData()
    }
    
    static func deleteData() {
        let cd = NSPersistentContainer(name: "nBack")
        cd.loadPersistentStores { (desc, error) in
            try! FileManager.default.removeItem(at: desc.url!)
        }
    }
    
}
