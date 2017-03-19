import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa
import Hero

class PlayCoordinator: Coordinator {
  
  var playViewController: PlayViewController { return viewController as! PlayViewController }
  
  override func loadViewController() {
    viewController = PlayViewController()
    playViewController.delegate = self
    
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
    navCoordinator.navigationController.isHeroEnabled = true
    
    self.present(navCoordinator, animated: true)
  }
}

extension PlayCoordinator: GameCoordinatorDelegate {
  func gameDidCancel() {
    self.dismiss(animated: true)
  }
  func gameDidFinish(with result: GameResultRealm) {
    playViewController.lastGameResult = result
    self.dismiss(animated: true)
  }
  
}
