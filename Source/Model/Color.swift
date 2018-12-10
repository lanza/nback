import UIKit

enum Color {
    case yellow
    case green
    case orange
    case black
    case purple
    case red
    case brown
    case blue
    
    static func from(value: Int) -> Color {
        switch value {
        case 0: return .yellow
        case 1: return .green
        case 2: return .orange
        case 3: return .black
        case 4: return .purple
        case 5: return .red
        case 6: return .brown
        case 7: return .blue
        default: fatalError()
        }
    }
    
    var color: UIColor {
        switch self {
        case .yellow: return UIColor.yellow
        case .green: return UIColor.green
        case .orange: return UIColor.orange
        case .black: return UIColor.black
        case .purple: return UIColor.purple
        case .red: return UIColor.red
        case .brown: return UIColor.brown
        case .blue: return UIColor.blue
        }
    }
}
