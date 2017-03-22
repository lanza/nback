import CoreData
import Foundation

final class CoreDataToRealmMigrator {
    static func fetchAllCoreDataGameResults() -> [GameResult] {
        return GameResult.fetch(in: CoreData.shared.context)
    }
    
    static func convertData() {
        let gameResults = fetchAllCoreDataGameResults()
        gameResults.forEach(processGameResult)
        deleteDatabase()
    }
    
    static func processGameResult(_ gameResult: GameResult) {
        let gameResultRealm = convertGameResult(gameResult)
        let typeResultRealms = convertTypeResults(for: gameResult)
        typeResultRealms.forEach(gameResultRealm.add)
    }
    
    static func convertGameResult(_ result: GameResult) -> GameResultRealm {
            let gameResultRealm = GameResultRealm.new(columns: Int(result.columns), rows: Int(result.rows), level: Int(result.level), numberOfTurns: Int(result.numberOfTurns), secondsBetweenTurns: result.secondsBetweenTurns, squareHighlightTime: result.squareHighlightTime)
        return gameResultRealm
    }
    static func convertTypeResults(for gameResult: GameResult) -> [TypeResultRealm] {
        return gameResult.types.map(convertTypeResult)
    }
    static func convertTypeResult(_ typeResult: TypeResult) -> TypeResultRealm {
        let score = Score(falseFalse: Int(typeResult.falseFalse), falseTrue: Int(typeResult.falseTrue), trueFalse: Int(typeResult.trueFalse), trueTrue: Int(typeResult.trueTrue))
        
        let typeResultRealm = TypeResultRealm.new(score: score, nBackType: typeResult.type)
        return typeResultRealm
    }
   
    static func deleteDatabase() {
        let cd = NSPersistentContainer(name: "nBack")
        cd.loadPersistentStores { (desc, error) in
            try! FileManager.default.removeItem(at: desc.url!)
        }
    }
    
}
