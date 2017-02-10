import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa

class PlayCoordinator: Coordinator {
  
  var playViewController: PlayViewController { return viewController as! PlayViewController }
  
  override func loadViewController() {
    viewController = PlayViewController()
    
    playViewController.title = "nBack"
    playViewController.tabBarItem.title = Lets.playl10n
    playViewController.tabBarItem.image = #imageLiteral(resourceName: "play")
  }
  
  let db = DisposeBag()
}

extension PlayCoordinator: PlayViewControllerDelegate {
  func newGameTapped() {
    let gameCoordinator = GameCoordinator()
    gameCoordinator.delegate = self
    let navCoordinator = NavigationCoordinator(rootCoordinator: gameCoordinator)
    
    self.present(navCoordinator, animated: true)
  }
}

extension PlayCoordinator: GameCoordinatorDelegate {
  func gameDidCancel() {
    self.dismiss(animated: true)
  }
  func gameDidFinish(with result: GameResult) {
    playViewController.lastGameResult = result
    self.dismiss(animated: true)
  }
  
}
