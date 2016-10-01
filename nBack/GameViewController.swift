import UIKit
import Foundation

class GameViewController: ViewController {
    
    weak var delegate: GameViewControllerDelegate!
    
    var gameBrain: GameBrain!
    var gameView: GameView { return view as! GameView }
    
    override func loadView() {
        view = GameView(rows: GameSettings.shared.rows, columns: GameSettings.shared.columns, types: GameSettings.shared.types)
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override init() {
        super.init()
        
        self.gameBrain = GameBrain(squareMatrix: gameView.squareMatrix, delegate: self)
        setupGameViewClosures()
    }
    
    func setupGameViewClosures() {
        gameView.setupClosures(gameBrain: gameBrain, quitGameClosure: gameDidCancel)
    }
    
    func gameDidCancel() {
        gameBrain.quit()
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



