import UIKit

class GameCoordinator: NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    weak var gameDelegate: GameCoordinatorDelegate!

    
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
        gameDelegate.gameCoordinatorDidCancel(self)
    }
    func gameDidFinish(for gameViewController: GameViewController, with result: GameResult) {
        gameViewController.presentingViewController?.dismiss(animated: true) {
            
        }
        gameDelegate.gameCoordinatorDidFinish(self, with: result)
    }
    
}

protocol GameCoordinatorDelegate: class {
    func gameCoordinatorDidFinish(_ coordinator: GameCoordinator, with result: GameResult)
    func gameCoordinatorDidCancel(_ coordinator: GameCoordinator)
}
