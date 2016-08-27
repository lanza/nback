import UIKit

class PlayViewController: ViewController, HasContext {
    
    var delegate: PlayViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        
        let button = UIButton(type: .system)
        button.setTitle("Play Game", for: .normal)
        button.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(button.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(button.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func newGameTapped() {
        let settings = GameSettings(rows: 4, columns: 3, types: [.numbers, .squares])
        delegate?.newGameTapped(for: self, settings: settings)
    }
    
}

protocol PlayViewControllerDelegate {
    func newGameTapped(for playViewController: PlayViewController, settings: GameSettings)
}


struct GameSettings {
    var rows: Int
    var columns: Int
    var types: [GameType]
}
