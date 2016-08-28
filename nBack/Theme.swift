import UIKit

struct Theme: HasWindow {
    static func setupAppearances() {
        window.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        

    }
    
    enum Colors {
        case normalSquare
        case highlightedSquare
        case matchButtonBackground
        
        var color: UIColor {
            switch self {
            case .highlightedSquare: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case .normalSquare: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .matchButtonBackground: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
    }
    
    enum Fonts {
        case label
        
        var font: UIFont {
            switch self {
            case .label: return UIFont.systemFont(ofSize: 13)
            }
        }
    }
}
