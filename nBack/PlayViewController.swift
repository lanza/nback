import UIKit

class PlayViewController: ViewController, HasContext {
    
    var lastGameResult: GameResult?
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
        delegate?.newGameTapped(for: self)
    }
    
}

protocol PlayViewControllerDelegate {
    func newGameTapped(for playViewController: PlayViewController)
}



