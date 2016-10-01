import Foundation
import CoreGraphics

struct SettingsValues<Type> {
    var min: Type
    var max: Type
    var increment: Type
}

struct Lets {
    
    //MARK: - Score Strings
    static func resultString(for result: GameResult) -> String {
        var typeCountString: String
        
        switch result.types.count {
        case 1: typeCountString = "Single"
        case 2: typeCountString = "Dual"
        case 3: typeCountString = "Tri"
        default: fatalError()
        }

        let parenthesisString = "(" + result.types.sorted { $0.type.string < $1.type.string }.map { $0.type.string }.joined(separator: ", ") + ")"
        let countBackString = "\(result.level)-back with \(result.numberOfTurns) turns."
        return typeCountString + " " + parenthesisString + " " + countBackString
    }
    
    static func scoreString(for result: GameResult) -> String {
        let totalCorrect = result.types.map { return $0.correct }.reduce(0) { $0 + $1 }
        let totalIncorrect = result.types.map { return $0.incorrect }.reduce(0) { $0 + $1 }
        return "\(totalCorrect) correct and \(totalIncorrect) incorrect."
    }
    
    
    //MARK: - Values
    static let secondsBetweenTurns = SettingsValues(min: 1, max: 5, increment: 0.5)
    static let levels = SettingsValues(min: 2, max: 7, increment: 1)
    static let turns = SettingsValues(min: 5, max: 40, increment: 5)
    static let rows = SettingsValues(min: 1, max: 6, increment: 1)
    static let columns = SettingsValues(min: 1, max: 6, increment: 1)
    
    //Strings
    static let playl10n = NSLocalizedString("Play", comment: "")
    static let historyl10n = NSLocalizedString("History", comment: "")
    static let settingsl10n = NSLocalizedString("Settings", comment: "")
    
    //GameTypes Strings
    static let numbersl10n = NSLocalizedString("Numbers", comment: "")
    static let squaresl10n = NSLocalizedString("Squares", comment: "")
    static let colorsl10n = NSLocalizedString("Colors", comment: "")
    
    static let matchButtonHeight = CGFloat(60)
    
    static let cellIdentifier = "cell"
    
    //MARK: - PlayVC Strings
    static var secondsBetweenTurnsString: String {
        return NSLocalizedString("\(GameSettings.shared.secondsBetweenTurns) seconds between turns", comment: "")
    }
    static var levelString: String {
        return NSLocalizedString("\(GameSettings.shared.level)-back", comment: "")
    }
    static var turnsString: String {
        return NSLocalizedString("\(GameSettings.shared.numberOfTurns) turns", comment: "")
    }
    static var rowsString: String {
        return NSLocalizedString("\(GameSettings.shared.rows) rows", comment: "")
    }
    static var columnsString: String {
        return NSLocalizedString("\(GameSettings.shared.columns) columns", comment: "")
    }
    static var numbersString: String {
        return NSLocalizedString("\(Lets.numbersl10n) \(GameSettings.shared.types.contains(.numbers) ? "On" : "Off")", comment: "")
    }
    static var squaresString: String {
        return NSLocalizedString("\(Lets.squaresl10n) \(GameSettings.shared.types.contains(.squares) ? "On" : "Off")", comment: "")
    }
    static var colorsString: String {
        return NSLocalizedString("\(Lets.colorsl10n) \(GameSettings.shared.types.contains(.colors) ? "On" : "Off")", comment: "")
    }
    
    //MARK: - Other UserDefaults keys
    static var lastScoreString = "lastScoreString"
    static var lastResultString = "lastResultString"
    
    //GameSettings
    static let secondsBetweenTurnsKey = "secondsBetweenTurns"
    static let squareHighlightTimeKey = "squareHighlightTime"
    static let typesKey = "types"
    static let levelKey = "level"
    static let rowsKey = "rows"
    static let columnsKey = "columns"
    static let numberOfTurnsKey = "numberOfTurns"
    
    static let cellLabelDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        return df
    }()
    static let headerDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM yyyy"
        return df
    }()
    static let sectionIdentifierDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df
    }()
}



extension Double {
    var nanoseconds: Double {
        return Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}

