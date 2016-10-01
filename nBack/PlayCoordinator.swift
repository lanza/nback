import UIKit

class PlayCoordinator: NSObject, NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    let playViewController = PlayViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        playViewController.delegate = self
        playViewController.title = "nBack"
        playViewController.tabBarItem.title = Lets.playl10n
        playViewController.tabBarItem.image = #imageLiteral(resourceName: "play")
    }
    
}

extension PlayCoordinator: PlayViewControllerDelegate {    
    
    func newGameTapped(for playViewController: PlayViewController) {
        let gameCoordinator = GameCoordinator()
        gameCoordinator.delegate = self
        gameCoordinator.gameDelegate = self
        coordinators.append(gameCoordinator)
        gameCoordinator.start()
        playViewController.present(gameCoordinator.gameViewController, animated: true)
    }
}

extension PlayCoordinator: CoordinatorDelegate { }
extension PlayCoordinator: GameCoordinatorDelegate {
    func gameCoordinatorDidFinish(_ coordinator: GameCoordinator, with result: GameResult) {
        playViewController.lastGameResult = result
    }
    func gameCoordinatorDidCancel(_ coordinator: GameCoordinator) {
        //
    }
}

extension PlayCoordinator: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
