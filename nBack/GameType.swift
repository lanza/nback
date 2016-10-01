import Foundation

public enum GameType {
    case numbers
    case squares
    case colors
    
    var string: String {
        switch self {
        case .numbers: return Lets.numbersl10n
        case .squares: return Lets.squaresl10n
        case .colors:  return Lets.colorsl10n
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

