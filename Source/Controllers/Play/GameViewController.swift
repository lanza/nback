import UIKit
import Foundation
import RxSwift
import RxCocoa
import Reuse

protocol GameViewControllerDelegate: class {
   func gameDidFinish(with result: GameResultRealm)
   func gameDidCancel()
}

class GameViewController: ViewController {
   
   weak var delegate: GameViewControllerDelegate!
   
   var gameBrain: GameBrain!
   var gameView: GameView { return view as! GameView }
   
   override func loadView() {
      view = GameView(delegate: self)
   }
   
   override init() {
      super.init()
      
      gameBrain = GameBrain(delegate: self)
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel Game", style: .done)
      navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: gameDidCancel).addDisposableTo(db)
   }
   
   
   func gameDidCancel() {
      gameBrain.quit()
      delegate.gameDidCancel()
   }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   
   override func viewDidAppear(_ animated: Bool) {
      gameBrain.start()
   }
   
   let db = DisposeBag()
}

extension GameViewController: GameBrainDelegate {
   func gameBrainDidFinish(with result: GameResultRealm) {
      delegate.gameDidFinish(with: result)
   }
   func enableButtons() {
      gameView.enableButtons()
   }
   func colorGameView(row: Int, column: Int, color: UIColor) {
      gameView.color(row: row, column: column, color: color)
      
   }
}

extension GameViewController: GameViewDelegate {
   func buttonWasTapped(type: NBackType) {
      gameBrain.playerStatesMatch(for: type)
   }
   
}




