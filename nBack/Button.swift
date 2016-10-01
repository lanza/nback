import UIKit

class Button: UIButton {
    static func matchButton(title: String, target: Any?, selector: Selector) -> Button {
        
        let button = Button(type: .system)
        
        button.setTitle(title, for: UIControlState())
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        button.backgroundColor = Theme.Colors.matchButtonBackground.color
        button.titleLabel?.font = Theme.Fonts.playPlay.font
        return button
    }
    
    static func quitGameButton(target: Any?, selector: Selector) -> Button {
        let button = Button(type: .system)
        
        button.setTitle("Quit Game", for: UIControlState())
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        return button
    }
}
