import UIKit

class GameCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    let gameViewController = GameViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        gameViewController.delegate = self
    }
    
}

extension GameCoordinator: GameViewControllerDelegate {
    
    func gameDidCancel(for gameViewController: GameViewController) {
        gameViewController.presentingViewController?.dismiss(animated: true) {
        
        }
        delegate?.coordinatorIsDone(self)
    }
    func gameDidFinish(for gameViewController: GameViewController, with result: GameResult) {
        gameViewController.presentingViewController?.dismiss(animated: true) {
            
        }
        delegate?.coordinatorIsDone(self)
    }
    
}
