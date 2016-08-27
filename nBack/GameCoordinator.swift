import UIKit

class GameCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    let gameViewController: GameViewController
    var coordinators = [NBCoordinator]()
    
    init(settings: GameSettings) {
        gameViewController = GameViewController(settings: settings)
        gameViewController.delegate = self
    }
    func start() {
        //nothing to do yet?
    }
    
    
}

extension GameCoordinator: GameViewControllerDelegate {
    func gameDidCancel(for gameViewController: GameViewController) {
        gameViewController.presentingViewController?.dismiss(animated: true) {
        
        }
        delegate?.coordinatorIsDone(self)
    }
    func gameDidFinish(for gameViewController: GameViewController, with result: GameResult) {
        //
    }
}
