import Foundation

public enum GameType {
    case numbers
    case squares
    case colors
    
    var string: String {
        switch self {
        case .numbers:
            return NSLocalizedString("Numbers", comment: "")
        case .squares:
            return NSLocalizedString("Squares", comment: "")
        case .colors:
            return NSLocalizedString("Colors", comment: "")
        }
    }
    
    static func from(value: Int) -> GameType {
        switch value {
        case 0: return .numbers
        case 1: return .squares
        case 2: return .colors
        default: fatalError()
        }
    }
    
    var value: Int {
        switch self {
        case .numbers: return 0
        case .squares: return 1
        case .colors: return 2
        }
    }
}

