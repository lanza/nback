import Foundation
import CoreGraphics

struct SettingsValues<Type> {
    var min: Type
    var max: Type
    var increment: Type
}

struct Lets {
    
    //MARK: - Score Strings
    static func resultString(for result: GameResultRealm) -> String {
        let typeCountString = Lets.nBackTypeCountString(for: result)
        let parenthesisString = Lets.nBackTypeListString(for: result)
        let countBackString = "\(result.level)-back with \(result.numberOfTurns) turns."
        return typeCountString + " " + parenthesisString + " " + countBackString
    }
    static func nBackTypeCountString(for result: GameResultRealm) -> String {
        switch result.types.count {
        case 1: return "Single"
        case 2: return "Dual"
        case 3: return "Tri"
        default: fatalError()
        }
    }
    static func nBackTypeListString(for result: GameResultRealm) -> String {
        return "(" + result.types.sorted { $0.nBackType.string < $1.nBackType.string }.map { $0.nBackType.string }.joined(separator: ", ") + ")"
    }
    
    static func scoreString(for result: GameResultRealm) -> String {
        return "\(result.totalCorrect) correct and \(result.totalIncorrect) incorrect."
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
    
    //nBack Type Strings
    static let numbersl10n = NSLocalizedString("Numbers", comment: "")
    static let squaresl10n = NSLocalizedString("Squares", comment: "")
    static let colorsl10n = NSLocalizedString("Colors", comment: "")
    
    static let matchButtonHeight = CGFloat(60)
    
    static let cellIdentifier = "cell"
    
    //MARK: - PlayVC Strings
    static var secondsBetweenTurnsString: String {
        return NSLocalizedString("\(GameSettings.secondsBetweenTurns) seconds between turns", comment: "")
    }
    static var levelString: String {
        return NSLocalizedString("\(GameSettings.level)-back", comment: "")
    }
    static var turnsString: String {
        return NSLocalizedString("\(GameSettings.numberOfTurns) turns", comment: "")
    }
    static var rowsString: String {
        return NSLocalizedString("\(GameSettings.rows) rows", comment: "")
    }
    static var columnsString: String {
        return NSLocalizedString("\(GameSettings.columns) columns", comment: "")
    }
    static var numbersString: String {
        return NSLocalizedString("\(Lets.numbersl10n) \(GameSettings.types.contains(.numbers) ? "On" : "Off")", comment: "")
    }
    static var squaresString: String {
        return NSLocalizedString("\(Lets.squaresl10n) \(GameSettings.types.contains(.squares) ? "On" : "Off")", comment: "")
    }
    static var colorsString: String {
        return NSLocalizedString("\(Lets.colorsl10n) \(GameSettings.types.contains(.colors) ? "On" : "Off")", comment: "")
    }
    
    //MARK: - Other UserDefaults keys
    static var lastScoreStringKey = "lastScoreString"
    static var lastResultStringKey = "lastResultString"
    
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

