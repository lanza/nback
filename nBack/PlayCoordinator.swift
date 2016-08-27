import UIKit

class PlayCoordinator: NSObject, NBCoordinator {
    
    weak var delegate: CoordinatorDelegate!
    
    let playViewController = PlayViewController()
    var coordinators = [NBCoordinator]()
    
    func start() {
        playViewController.delegate = self
        playViewController.title = Lets.playl10n
        playViewController.tabBarItem.title = Lets.playl10n
        playViewController.tabBarItem.image = nil
    }
    
}

extension PlayCoordinator: PlayViewControllerDelegate {    
    
    func newGameTapped(for playViewController: PlayViewController, settings: GameSettings) {
        let gameCoordinator = GameCoordinator(settings: settings)
        gameCoordinator.delegate = self
        coordinators.append(gameCoordinator)
        gameCoordinator.start()
        print(coordinators)
        playViewController.present(gameCoordinator.gameViewController, animated: true)
    }
}

extension PlayCoordinator: CoordinatorDelegate { }

extension PlayCoordinator: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

