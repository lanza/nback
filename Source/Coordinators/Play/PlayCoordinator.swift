import CoordinatorKit
import UIKit

class PlayCoordinator: Coordinator {
  var playViewController: PlayViewController {
    return viewController as! PlayViewController
  }

  override func loadViewController() {
    viewController = PlayViewController()
    playViewController.delegate = self

    playViewController.title = "nBack"
    playViewController.tabBarItem.title = Lets.playl10n
    playViewController.tabBarItem.image = #imageLiteral(resourceName: "play")
  }
}

extension PlayCoordinator: PlayViewControllerDelegate {
  func newGameTapped() {
    let gameCoordinator = GameCoordinator()
    gameCoordinator.delegate = self
    let navCoordinator = NavigationCoordinator(rootCoordinator: gameCoordinator)

    present(navCoordinator, animated: true)
  }
}

extension PlayCoordinator: GameCoordinatorDelegate {
  func gameDidCancel() {
    dismiss(animated: true)
  }

  func gameDidFinish(with result: GameResult) {
    playViewController.lastGameResult = result
    dismiss(animated: true)
  }
}
