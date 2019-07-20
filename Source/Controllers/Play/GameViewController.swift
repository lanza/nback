import Foundation
import UIKit

protocol GameViewControllerDelegate: AnyObject {
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

        gameBrain = GameBrain(squareMatrix: gameView.squareMatrix, delegate: self)
        setupGameViewClosures()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel Game", style: .done, target: self, action: #selector(gameDidCancel))
    }

    func setupGameViewClosures() {
        gameView.setupClosures(gameBrain: gameBrain, quitGameClosure: gameDidCancel)
    }

    @objc func gameDidCancel() {
        gameBrain.quit()
        gameView.setupClosures(gameBrain: nil, quitGameClosure: nil)

        delegate.gameDidCancel()
    }

    func gameDidFinish(with gameResult: GameResult) {
        gameView.setupClosures(gameBrain: nil, quitGameClosure: nil)

        delegate.gameDidFinish(with: gameResult)
    }

    required init?(coder _: NSCoder) { fatalError() }

    override func viewDidAppear(_: Bool) {
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
