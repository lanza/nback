import UIKit
import CoreGraphics

class GameView: View {
    
    var squareMatrix: SquareMatrix!
    
    var mainStackView: StackView!
    var buttons: [Button]!
    var buttonStackView: StackView!
    var quitGameButton: Button!
    
    init(rows: Int, columns: Int, types: [GameType]) {
        super.init(frame: CGRect())
        
        layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        if GameSettings.shared.types.contains(.squares) {
            setupSquares(rows: rows, columns: columns)
        } else if GameSettings.shared.types.contains(.colors) {
            setupSquares(rows: 1, columns: 1)
        }
        setupMatchButtons(types: types)
        setupQuitButton()
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    var colorsButtonClosure: (() -> ())!
    func colorsButtonTapped() { colorsButtonClosure() }
    var squaresButtonClosure: (() -> ())!
    func squaresButtonTapped() { squaresButtonClosure() }
    var numbersButtonClosure: (() -> ())!
    func numbersButtonTapped() { numbersButtonClosure() }
    
    func setupClosures(gameBrain: GameBrain?, quitGameClosure: (() -> ())?) {
        self.colorsButtonClosure = gameBrain?.playerStatesColorsMatched
        self.squaresButtonClosure = gameBrain?.playerStatesSquaresMatched
        self.numbersButtonClosure = gameBrain?.playerStatesNumbersMatched
        
        self.quitGameClosure = quitGameClosure
    }
    
    var quitGameClosure: (() -> ())!
    func quitGameTapped() { quitGameClosure() }
    
    private func setupQuitButton() {
        quitGameButton = Button.quitGameButton(target: self, selector: #selector(quitGameTapped))
        addSubview(quitGameButton)
    }
    
    private func setupMatchButtons(types: [GameType]) {
        
        buttons = [Button]()
        
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
            
            let button = Button.matchButton(title: type.string, target: self, selector: selector)
            button.isEnabled = false
            
            buttons.append(button)
        }
        
        buttonStackView = StackView(arrangedSubviews: buttons, axis: .horizontal, spacing: 1, distribution: .fillEqually)
        addSubview(buttonStackView)
    }
    
    private func setupSquares(rows: Int, columns: Int) {
        
        self.rows = rows
        self.columns = columns
        
        var elements = [SquareView]()
        var rowStackViews = [StackView]()
        
        for _ in 1...rows {
            var columnViews = [SquareView]()
            for _ in 1...columns {
                let squareView = SquareView()
                columnViews.append(squareView)
                elements.append(squareView)
            }
            
            let rowStackView = StackView(arrangedSubviews: columnViews, axis: .horizontal, spacing: 1, distribution: .fillEqually)
            rowStackViews.append(rowStackView)
        }
        mainStackView = StackView(arrangedSubviews: rowStackViews, axis: .vertical, spacing: 1, distribution: .fillEqually)
        addSubview(mainStackView)
        squareMatrix = SquareMatrix(rows: rows, columns: columns, elements: elements)
    }
    
    var rows = 0
    var columns = 0
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -24))
        constraints.append(mainStackView.widthAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: CGFloat(squareMatrix.columns) / CGFloat(squareMatrix.rows)))
        constraints.append(mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor))
        

        let boardWidth = frame.width - 40
        let boardHeight = frame.height - (8 + 16 + 8 + 8) - quitGameButton.frame.height - buttonStackView.frame.height
        
        if boardHeight/boardWidth < CGFloat(rows)/CGFloat(columns) {
            constraints.append(mainStackView.heightAnchor.constraint(equalToConstant: boardHeight))
        } else {
            constraints.append(mainStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
            constraints.append(mainStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
        }
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16))
        constraints.append(buttonStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
        constraints.append(buttonStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
        constraints.append(buttonStackView.heightAnchor.constraint(equalToConstant: Lets.matchButtonHeight))
        
        quitGameButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(quitGameButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8))
        constraints.append(quitGameButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func enableButtons() {
        buttons.forEach { $0.isEnabled = true }
    }
}
