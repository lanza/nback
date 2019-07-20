import UIKit

class Button: UIButton {
    static func matchButton(title: String, target: Any?, selector: Selector) -> Button {
        let button = Button(type: .system)

        button.setTitle(title, for: UIControl.State())
        button.addTarget(target, action: selector, for: .touchUpInside)

        button.backgroundColor = Theme.Colors.matchButtonBackground
        button.setTitleColor(Theme.Colors.matchButtonFont, for: UIControl.State())
        button.titleLabel?.font = Theme.Fonts.matchButtons
        return button
    }

    static func quitGameButton(target: Any?, selector: Selector) -> Button {
        let button = Button(type: .system)

        button.setTitle("Quit Game", for: UIControl.State())
        button.addTarget(target, action: selector, for: .touchUpInside)

        return button
    }
}

extension UIButton {
    static func button(title: String, target: Any?, selector: Selector?, font: UIFont) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        if let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
        }
        button.titleLabel?.font = font
        button.backgroundColor = Theme.Colors.settingsButtonsBackground
        button.setTitleColor(Theme.Colors.settingsFont, for: UIControl.State())
        button.layer.cornerRadius = 5
        return button
    }

    func set(title: String) {
        setTitle(title, for: .normal)
    }
}
