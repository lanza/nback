import UIKit
import Foundation

class GameViewController: ViewController {
    
    weak var delegate: GameViewControllerDelegate?
    
    var gameBrain: GameBrain
    var settings: GameSettings
    var gameView: GameView
    
    init(settings: GameSettings) {
        
        self.settings = settings
        self.gameView = GameView(rows: settings.rows, columns: settings.columns, types: settings.types)
        self.gameBrain = GameBrain(squareMatrix: gameView.squareMatrix)
        
        super.init()
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct GameBrain {
    
    var squareMatrix: SquareMatrix
    
    func squaresButtonTapped() {}
    func numbersButtonTapped() {}
    func colorsButtonTapped() {}
}



class GameView: View {
    
    var squareMatrix: SquareMatrix!
    
    var mainStackView: StackView!
    var buttonStackView: StackView!
    var quitGameButton: Button!
    
    init(rows: Int, columns: Int, types: [GameType]) {
        super.init(frame: CGRect())
        
        setupSquares(rows: rows, columns: columns)
        setupMatchButtons(types: types)
        setupQuitButton()
        
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    var colorsButtonClosure: (() -> ())!
    func colorsButtonTapped() { colorsButtonClosure() }
    var squaresButtonClosure: (() -> ())!
    func squaresButtonTapped() { squaresButtonClosure() }
    var numbersButtonClosure: (() -> ())!
    func numbersButtonTapped() { numbersButtonClosure() }
    
    func setupClosures(gameBrain: GameBrain?, quitGameClosure: (() -> ())?) {
        self.colorsButtonClosure = gameBrain?.colorsButtonTapped
        self.squaresButtonClosure = gameBrain?.squaresButtonTapped
        self.numbersButtonClosure = gameBrain?.numbersButtonTapped
        
        self.quitGameClosure = quitGameClosure
    }
    
    var quitGameClosure: (() -> ())!
    func quitGameTapped() { quitGameClosure() }
    
    private func setupQuitButton() {
        quitGameButton = Button.quitGameButton(target: self, selector: #selector(quitGameTapped))
        addSubview(quitGameButton)
    }
    
    private func setupMatchButtons(types: [GameType]) {
        
        var buttons = [Button]()
        
        for type in types {
            
            var selector: Selector
            
            switch type {
            case .colors:
                selector = #selector(colorsButtonTapped)
            case .numbers:
                selector = #selector(numbersButtonTapped)
            case .squares:
                selector = #selector(squaresButtonTapped)
            }
            
            let button = Button.matchButton(title: type.buttonString, target: self, selector: selector)
            
            buttons.append(button)
        }
        
        buttonStackView = StackView(arrangedSubviews: buttons, axis: .horizontal, spacing: 1, distribution: .fillEqually)
        addSubview(buttonStackView)
    }
    
    private func setupSquares(rows: Int, columns: Int) {
        
        var elements = [SquareView]()
        var rowStackViews = [StackView]()
        
        for _ in 1...rows {
            var columnViews = [SquareView]()
            for _ in 1...columns {
                let squareView = SquareView()
                columnViews.append(squareView)
                elements.append(squareView)
                
                squareView.backgroundColor = .red
            }
            
            let rowStackView = StackView(arrangedSubviews: columnViews, axis: .horizontal, spacing: 1, distribution: .fillEqually)
            rowStackViews.append(rowStackView)
        }
        mainStackView = StackView(arrangedSubviews: rowStackViews, axis: .vertical, spacing: 1, distribution: .fillEqually)
        addSubview(mainStackView)
        squareMatrix = SquareMatrix(rows: rows, columns: columns, elements: elements)
    }
    
    private func setupConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor))
        constraints.append(mainStackView.widthAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: CGFloat(squareMatrix.columns) / CGFloat(squareMatrix.rows)))
        constraints.append(mainStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
        constraints.append(mainStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
        //constrain so that the height is less than necessary
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(buttonStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor))
        constraints.append(buttonStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
        constraints.append(buttonStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
        constraints.append(buttonStackView.heightAnchor.constraint(equalToConstant: Lets.matchButtonHeight))
        
        quitGameButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(quitGameButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor))
        constraints.append(quitGameButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
}

class SquareMatrix {
    var rows: Int
    var columns: Int
    private var elements: [SquareView]
    
    init(rows: Int, columns: Int, elements: [SquareView]) {
        self.rows = rows
        self.columns = columns
        self.elements = elements
    }
    
    subscript (row: Int, column: Int) -> SquareView {
        return elements[row * columns + column]
    }
    
    func color(row: Int, column: Int, for: TimeInterval) {
        let square = self[row,column]
        square.backgroundColor = Theme.Colors.highlightedSquare.color
        let deadline: DispatchTime = DispatchTime.now() + GameValues.squareHighlightTime.nanoseconds
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            square.backgroundColor = Theme.Colors.normalSquare.color
        }
    }
}

protocol GameViewControllerDelegate: class {
    func gameDidFinish(for gameViewController: GameViewController, with result: GameResult)
    func gameDidCancel(for gameViewController: GameViewController)
}



