import CoreData

import Foundation

final class Initializer {
    
    static let defaults = UserDefaults.standard
    
    static func run() {
        if defaults[.hasDoneSetup] == nil {
            GameSettings.setDefaults()
            defaults[.lastScoreString] = "Welcome to nBack"
            defaults[.lastResultString] = ""
            
            defaults[.hasDoneSetup] = true
        }
        
        if defaults[.hasConvertedFromCoreData] == nil {
            CoreDataToRealmMigrator.convertData()
            defaults[.hasConvertedFromCoreData] = true
        }
    }
    
}


