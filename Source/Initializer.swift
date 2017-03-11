import CoreData

import Foundation

class Initializer {
    
    static let defaults = UserDefaults.standard
    
    static func run() {
        if defaults[.hasDoneSetup] == nil {
            GameSettings.setDefaults()
            defaults[.lastScoreString] = "Welcome to nBack"
            defaults[.lastResultString] = ""
            
            defaults[.hasDoneSetup] = true
        }
        
        if defaults[.hasConvertedFromCoreData] == nil {
            convertData()
            defaults[.hasConvertedFromCoreData] = true
        }
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
        
        let cd = NSPersistentContainer(name: "nBack")
        cd.loadPersistentStores { (desc, error) in
            try! FileManager.default.removeItem(at: desc.url!)
        }
    }
}
