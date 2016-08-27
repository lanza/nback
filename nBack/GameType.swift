import Foundation

enum GameType {
    case numbers
    case squares
    case colors
    
    var buttonString: String {
        switch self {
        case .numbers:
            return NSLocalizedString("Numbers", comment: "")
        case .squares:
            return NSLocalizedString("Squares", comment: "")
        case .colors:
            return NSLocalizedString("Colors", comment: "")
        }
    }
}

