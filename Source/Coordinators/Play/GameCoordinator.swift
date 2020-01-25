import UIKit

protocol GameCoordinatorDelegate: AnyObject {
  func gameDidFinish(with result: GameResult)
  func gameDidCancel()
}

class GameCoordinator: Coordinator {
  weak var delegate: GameCoordinatorDelegate!

  var gameViewController: GameViewController {
    return viewController as! GameViewController
  }

  override func loadViewController() {
    viewController = GameViewController()
    gameViewController.delegate = self
  }
}

extension GameCoordinator: GameViewControllerDelegate {
  func gameDidFinish(with result: GameResult) {
    delegate.gameDidFinish(with: result)
  }

  func gameDidCancel() {
    delegate.gameDidCancel()
  }
}
