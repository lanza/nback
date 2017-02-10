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
    
    playViewController.newGameTapped = { [unowned self] pvc in
      self.startNewGame()
    }
  }
  
  func startNewGame() {
    let gameCoordinator = GameCoordinator()
    gameCoordinator.delegate = self
    
    gameCoordinator.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel Game", style: .done, target: nil, action: nil)
    gameCoordinator.navigationItem.rightBarButtonItem!.rx.tap.subscribe(onNext: {
      gameCoordinator.gameViewController.gameDidCancel()
    }).addDisposableTo(self.db)
    let navCoordinator = NavigationCoordinator(rootCoordinator: gameCoordinator)
    self.present(navCoordinator, animated: true)
  }
  
  
  let db = DisposeBag()
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
