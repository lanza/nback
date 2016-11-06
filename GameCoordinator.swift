import UIKit
import CoordinatorKit

class GameCoordinator: Coordinator {
    
    var gameViewController: GameViewController { return viewController as! GameViewController }
    
    override func loadViewController() {
        viewController = GameViewController()
        gameViewController.gameDidFinish = { [unowned self] result in
            self.gameDidFinish(result)
            self.dismiss(animated: true)
        }
        gameViewController.gameDidCancelClosure = { [unowned self] _ in
            self.dismiss(animated: true)
        }
    }
    
    var gameDidFinish: ((GameResult) -> ())!
}
