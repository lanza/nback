import UIKit

struct Theme: HasWindow {
    static func setupAppearances() {

        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = Colors.tint.color
        navBarAppearance.titleTextAttributes = [
            NSForegroundColorAttributeName: Colors.tint.color
        ]
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.foreground.color
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.foreground.color
        tabBarAppearance.unselectedItemTintColor = Colors.typeDisabled.color
        tabBarAppearance.tintColor = Colors.tint.color
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.background.color
        
        let tableViewCellAppearance = UITableViewCell.appearance()
        tableViewCellAppearance.backgroundColor = Colors.background.color

        
        let viewAppearance = View.appearance()
        viewAppearance.backgroundColor = Colors.background.color
        
        
    }
    
    enum Colors {
        case tint
        case normalSquare
        case highlightedSquare
        case matchButtonBackground
        case playButtonBackground
        case typeDisabled
        case foreground
        case background
        
        
        var color: UIColor {
            switch self {
            case .tint: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .highlightedSquare: return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            case .normalSquare: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            case .matchButtonBackground: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .playButtonBackground: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .typeDisabled: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .foreground: return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            case .background: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    enum Fonts {
        case label
        case smallerLabel
        case playLabels
        case playPlay
        
        var font: UIFont {
            switch self {
            case .label: return UIFont.systemFont(ofSize: 13)
            case .smallerLabel: return UIFont.systemFont(ofSize: 11)
            case .playLabels: return UIFont.systemFont(ofSize: 21)
            case .playPlay: return UIFont.systemFont(ofSize: 28)
            }
        }
    }
}
