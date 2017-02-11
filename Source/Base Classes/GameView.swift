import UIKit
import Reuse
import RxSwift
import RxCocoa

protocol GameViewDelegate: class {
   
}

class GameView: View {
   
   unowned var delegate: GameViewDelegate
    
    var squareMatrix: SquareMatrix!
    
    var mainStackView: StackView!
    var buttons: [Button]!
    var buttonStackView: StackView!
   
   init(rows: Int, columns: Int, types: Set<NBackType>, delegate: GameViewDelegate) {
        super.init(frame: CGRect())
        
        layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        if GameSettings.types.contains(.squares) {
            setupSquares(rows: rows, columns: columns)
        } else {
            setupSquares(rows: 1, columns: 1)
        }
        setupMatchButtons(types: types)
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
   
    private func setupMatchButtons(types: Set<NBackType>) {
      
        buttons = [Button]()
        
        for type in types {
            let button = Button.matchButton(title: type.string)
         
            switch type {
            case .colors:
               button.rx.tap.subscribe(onNext: {}).addDisposableTo(db)
            case .numbers:
               button.rx.tap.subscribe(onNext: {}).addDisposableTo(db)
            case .squares:
               button.rx.tap.subscribe(onNext: {}).addDisposableTo(db)
            }
         
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
        let boardHeight = frame.height - (8 + 16 + 8 + 8) - buttonStackView.frame.height
        
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
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func enableButtons() {
        buttons.forEach { $0.isEnabled = true }
    }
   
   let db = DisposeBag()
}
