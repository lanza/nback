import UIKit
import CoordinatorKit

protocol GameCoordinatorDelegate: class {
  func gameDidFinish(with result: GameResultRealm)
  func gameDidCancel()
}

class GameCoordinator: Coordinator {
  
  weak var delegate: GameCoordinatorDelegate!
  
  var gameViewController: GameViewController { return viewController as! GameViewController }
  
  override func loadViewController() {
    viewController = GameViewController()
    gameViewController.delegate = self
  }
  
}

extension GameCoordinator: GameViewControllerDelegate {
  func gameDidFinish(with result: GameResultRealm) {
    delegate.gameDidFinish(with: result)
  }
  func gameDidCancel() {
    delegate.gameDidCancel()
  }
}

