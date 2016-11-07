import UIKit
import CoordinatorKit

class GameCoordinator: Coordinator {
    
    var gameViewController: GameViewController { return viewController as! GameViewController }
    
    override func loadViewController() {
        viewController = GameViewController()
        gameViewController.gameDidFinish = { result in
            self.gameDidFinish(result)
        }
        gameViewController.gameDidCancelClosure = { [unowned self] _ in
            self.gameDidFinish(nil)
        }
    }
    
    var gameDidFinish: ((GameResult?) -> ())!
}
