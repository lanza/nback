import UIKit
import Foundation

class GameViewController: ViewController {
    
    weak var delegate: GameViewControllerDelegate!
    
    var gameBrain: GameBrain!
    var gameView: GameView
    
    override init() {
        
        self.gameView = GameView(rows: GameSettings.shared.rows, columns: GameSettings.shared.columns, types: GameSettings.shared.types)
        
        super.init()
        
        self.gameBrain = GameBrain(squareMatrix: gameView.squareMatrix, delegate: self)
        
        setupGameViewClosures()
        gameView.frame = view.frame
        view.addSubview(gameView)
    }
    
    func setupGameViewClosures() {
        gameView.setupClosures(gameBrain: gameBrain, quitGameClosure: gameDidCancel)
    }
    
    func gameDidCancel() {
        gameView.setupClosures(gameBrain: nil, quitGameClosure: nil)
        delegate?.gameDidCancel(for: self)
    }
    func gameDidFinish(with gameResult: GameResult) {
        gameView.setupClosures(gameBrain: nil, quitGameClosure: nil)
        delegate?.gameDidFinish(for: self, with: gameResult)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidAppear(_ animated: Bool) {
        gameBrain.start()
    }
}


extension GameViewController: GameBrainDelegate {
    func gameBrainDidFinish(with result: GameResult) {
        delegate.gameDidFinish(for: self, with: result)
    }
    func enableButtons() {
        gameView.enableButtons()
    }
}




protocol GameViewControllerDelegate: class {
    func gameDidFinish(for gameViewController: GameViewController, with result: GameResult)
    func gameDidCancel(for gameViewController: GameViewController)
}



