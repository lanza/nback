import UIKit
import Foundation

protocol GameViewControllerDelegate: class {
  func gameDidFinish(with result: GameResult)
  func gameDidCancel()
}

class GameViewController: ViewController {
  
  weak var delegate: GameViewControllerDelegate!
  
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
    
    delegate.gameDidCancel()
  }
  var gameDidCancelClosure: (() -> ())!
  
  func gameDidFinish(with gameResult: GameResult) {
    gameView.setupClosures(gameBrain: nil, quitGameClosure: nil)
    
    delegate.gameDidFinish(with: gameResult)
  }
  required init?(coder aDecoder: NSCoder) { fatalError() }
  
  override func viewDidAppear(_ animated: Bool) {
    gameBrain.start()
  }
}




extension GameViewController: GameBrainDelegate {
  func gameBrainDidFinish(with result: GameResult) {
    gameDidFinish(with: result)
  }
  func enableButtons() {
    gameView.enableButtons()
  }
}





