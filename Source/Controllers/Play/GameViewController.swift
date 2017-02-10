import UIKit
import Foundation

class GameViewController: ViewController {

    var gameBrain: GameBrain!
    var gameView: GameView { return view as! GameView }
    
    override func loadView() {
        view = GameView(rows: GameSettings.shared.rows, columns: GameSettings.shared.columns, types: GameSettings.shared.types)
    }
    
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
        gameDidCancelClosure()
    }
    var gameDidCancelClosure: (() -> ())!
    func gameDidFinish(with gameResult: GameResult) {
        gameView.setupClosures(gameBrain: nil, quitGameClosure: nil)
        gameDidFinish(gameResult)
    }
    var gameDidFinish: ((GameResult) -> ())!
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override func viewDidAppear(_ animated: Bool) {
        gameBrain.start()
    }
}


extension GameViewController: GameBrainDelegate {
    func gameBrainDidFinish(with result: GameResult) {
        gameDidFinish(result)
    }
    func enableButtons() {
        gameView.enableButtons()
    }
}





