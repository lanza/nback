import UIKit

struct Theme: HasWindow {
    static func setupAppearances() {

        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = Colors.tint
        navBarAppearance.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([
            NSAttributedString.Key.foregroundColor.rawValue: Colors.tint
        ])
        navBarAppearance.barStyle = .black
        navBarAppearance.barTintColor = Colors.foreground
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.barStyle = .black
        tabBarAppearance.barTintColor = Colors.foreground
        tabBarAppearance.unselectedItemTintColor = Colors.typeDisabled
        tabBarAppearance.tintColor = Colors.tint
        
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = Colors.background
        
        let tableViewCellAppearance = UITableViewCell.appearance()
        tableViewCellAppearance.backgroundColor = Colors.background

        
        let viewAppearance = View.appearance()
        viewAppearance.backgroundColor = Colors.background
        
        
    }
    
    struct Colors {
        
        static let secondary = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        static let primary = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let gray = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        static let tint = Colors.white
        static let normalSquare = Colors.primary
        static let highlightedSquare = Colors.gray
        static let matchButtonBackground = Colors.secondary
        static let playButtonBackground = Colors.primary
        static let typeDisabled = Colors.gray
        static let foreground = Colors.secondary
        static let background = Colors.white
        static let settingsButtonsBackground = Colors.primary
        static let settingsFont = Colors.white
        static let matchButtonFont = Colors.white
        static let playButtonFont = Colors.white
    }

    struct Fonts {
        static let label = UIFont.systemFont(ofSize: 13)
        static let smallerLabel = UIFont.systemFont(ofSize: 11)
        static let playLabels = UIFont.systemFont(ofSize: 21)
        static let matchButtons = UIFont.systemFont(ofSize: 22)
        static let playPlay = UIFont.systemFont(ofSize: 28)
        static let lastGameLabel = UIFont.systemFont(ofSize: 18)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
