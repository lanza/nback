import Foundation
import CoreData


class GameResult: NSManagedObject {

    var totalCorrect: Int {
        var temporary = 0
        for backType in backTypes!  {
            temporary += Int(backType.correct!)
        }
        return temporary
    }
    
    var outOf: Int {
        
        var temporary = 0
        for backType in backTypes! {
            temporary += (Int(backType.incorrect!) + Int(backType.matches!))
        }
        
        return temporary
    }
    
    var scoreString: String {
        return "Score: \(self.totalCorrect)/\(self.outOf)"
    }
    
    var dateString: String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .MediumStyle
        let dateString = formatter.stringFromDate(self.date)
        formatter.timeStyle = .MediumStyle
        formatter.dateStyle = .NoStyle
        let timeString = formatter.stringFromDate(self.date)
        return "Played on: " + dateString + " at " + timeString
    }
    var backAndTurnsString: String {
        return "\(self.nbackLevel)-back with \(self.numberOfTurns) turns"
    }
}

struct Constants {
    static let gameResult = "GameResult"
    static let dateKey = "date"
    static let lettersCorrectKey = "lettersCorrect"
    static let squaresCorrectKey = "squaresCorrect"
    static let lettersIncorrectKey = "lettersIncorrect"
    static let squaresIncorrectKey = "squaresIncorrect"
    static let lettersMatchedKey = "lettersMatched"
    static let squaresMatchedKey = "squaresMatched"
    static let totalCorrectKey = "totalCorrect"
    static let outOfKey = "outOf"
    static let scoreStringKey = "scoreString"
    static let numberOfTurnsKey = "numberOfTurns"
    static let nbackLevelKey = "nbackLevel"
    static let secondsBetweenTurnsKey = "secondsBetweenTurns"
    static let blueSquareDurationKey = "blueSquareDuration"
    
    //here lies new stuff
    static let backTypesKey = "backTypes"
    //here lies new stuff
    
    static let lastGameTotalCorrectKey = "lastGameTotalCorrect"
    
    
    static let reuseIdentifier = "cell"
    
    static let configFileName = "config"
    static let plistExtension = "plist"
}



    

