import UIKit

class PlayView: UIView {
    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlayViewController: ViewController, HasContext {
    
    var lastGameResult: GameResult?
    var delegate: PlayViewControllerDelegate?
    
    var lastGameLabel: Label!
    
    var secondsBetweenTurnsButton: UIButton!
    
    var squareButton: UIButton!
    var numberButton: UIButton!
    var colorButton: UIButton!
    
    var levelButton: UIButton!
    var turnsButton: UIButton!
    
    var rowsButton: UIButton!
    var columnsButton: UIButton!
    
    var playGameButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if let lastScoreString = defaults.value(forKey: Lets.lastScoreString) as? String, let lastResultString = defaults.value(forKey: Lets.lastResultString) as? String {
            lastGameLabel.text = "Last Game: \n" + lastResultString + "\n" + lastScoreString
        }
    }
    override func loadView() {
        view = View()
        
        lastGameLabel = Label()
        lastGameLabel.numberOfLines = 0
        
        secondsBetweenTurnsButton = UIButton.button(title: Lets.secondsBetweenTurnsString, target: self, selector: #selector(secondsBetweenTurnsButtonTapped), font: .playLabels)
        let secondsBetweenTurnsStackView = StackView(arrangedSubviews: [secondsBetweenTurnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
        
        squareButton = UIButton.button(title: Lets.squaresString, target: self, selector: #selector(squareButtonTapped), font: .playLabels )
        squareButton.titleLabel?.numberOfLines = 2
        squareButton.titleLabel?.textAlignment = .center
        numberButton = UIButton.button(title: Lets.numbersString, target: self, selector: #selector(numberButtonTapped), font: .playLabels)
        numberButton.titleLabel?.numberOfLines = 2
        numberButton.titleLabel?.textAlignment = .center
        colorButton = UIButton.button(title: Lets.colorsString, target: self, selector: #selector(colorButtonTapped), font: .playLabels)
        colorButton.titleLabel?.numberOfLines = 2
        colorButton.titleLabel?.textAlignment = .center
        
        levelButton = UIButton.button(title: Lets.levelString, target: self, selector: #selector(levelButtonTapped), font: .playLabels)
        turnsButton = UIButton.button(title: Lets.turnsString, target: self, selector: #selector(turnsButtonTapped), font: .playLabels)
        let levelAndTurnsStackView = StackView(arrangedSubviews: [levelButton, turnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
        
        let squaresIsOn = GameSettings.shared.types.contains(.squares)
        rowsButton = UIButton.button(title: Lets.rowsString, target: self, selector: #selector(rowsButtonTapped), font: .playLabels)
        rowsButton.isEnabled = squaresIsOn
        columnsButton = UIButton.button(title: Lets.columnsString, target: self, selector: #selector(columnsButtonTapped), font: .playLabels)
        columnsButton.isEnabled = squaresIsOn
        let rowsAndColumnsStackView = StackView(arrangedSubviews: [rowsButton,columnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
        
        playGameButton = UIButton.button(title: Lets.playl10n, target: self, selector: #selector(newGameButtonTapped), font: .playPlay)
        playGameButton.backgroundColor = Theme.Colors.playButtonBackground.color
        playGameButton.layer.cornerRadius = 5
        let playGameButtonStackView = StackView(arrangedSubviews: [playGameButton], axis: .horizontal, spacing: 0, distribution: .fillEqually)
        
        var views: [UIView]
        
        if UIScreen.main.bounds.height > 700 {
            views = [lastGameLabel,secondsBetweenTurnsStackView, squareButton, numberButton, colorButton, levelAndTurnsStackView,rowsAndColumnsStackView,playGameButtonStackView]
        } else {
            let typeButtonsStackView = StackView(arrangedSubviews: [squareButton,numberButton,colorButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
            views = [lastGameLabel, secondsBetweenTurnsStackView, typeButtonsStackView, levelAndTurnsStackView, rowsAndColumnsStackView, playGameButtonStackView]
        }
        
        let stackView = StackView(arrangedSubviews: views, axis: .vertical, spacing: 8, distribution: .fillEqually)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor))

        NSLayoutConstraint.activate(constraints)
        view.setNeedsLayout()
    }
    
    func secondsBetweenTurnsButtonTapped() {
        if GameSettings.shared.secondsBetweenTurns == Lets.secondsBetweenTurns.max {
            GameSettings.shared.secondsBetweenTurns = Lets.secondsBetweenTurns.min
        } else {
            GameSettings.shared.secondsBetweenTurns += Lets.secondsBetweenTurns.increment
        }
        secondsBetweenTurnsButton.set(title: Lets.secondsBetweenTurnsString)
    }
    func typeButtonTapped(type: GameType, button: UIButton) {
        var types = GameSettings.shared.types
        if let index = types.index(of: type) {
            types.remove(at: index)
            GameSettings.shared.types = types
        } else {
            types.append(type)
            GameSettings.shared.types = types
        }
        if GameSettings.shared.types.count == 0 {
            playGameButton.isEnabled = false
        } else {
            playGameButton.isEnabled = true
        }
    }
    func numberButtonTapped() {
        typeButtonTapped(type: .numbers, button: numberButton)
        numberButton.set(title: Lets.numbersString)
    }
    func squareButtonTapped() {
        typeButtonTapped(type: .squares, button: squareButton)
        squareButton.set(title: Lets.squaresString)
        let isOn = GameSettings.shared.types.contains(.squares)
        rowsButton.isEnabled = isOn
        columnsButton.isEnabled = isOn
    }
    func colorButtonTapped() {
        typeButtonTapped(type: .colors, button: colorButton)
        colorButton.set(title: Lets.colorsString)
    }
    
    func levelButtonTapped() {
        if GameSettings.shared.level == Lets.levels.max {
            GameSettings.shared.level = Lets.levels.min
        } else {
            GameSettings.shared.level += Lets.levels.increment
        }
        levelButton.set(title: Lets.levelString)
    }
    func turnsButtonTapped() {
        if GameSettings.shared.numberOfTurns == Lets.turns.max {
            GameSettings.shared.numberOfTurns = Lets.turns.min
        } else {
            GameSettings.shared.numberOfTurns += Lets.turns.increment
        }
        turnsButton.set(title: Lets.turnsString)
    }
    
    func rowsButtonTapped() {
        if GameSettings.shared.rows == Lets.rows.max {
            GameSettings.shared.rows = Lets.rows.min
        } else {
            GameSettings.shared.rows += Lets.rows.increment
        }
        rowsButton.set(title: Lets.rowsString)
    }
    
    func columnsButtonTapped() {
        if GameSettings.shared.columns == Lets.columns.max {
            GameSettings.shared.columns = Lets.columns.min
        } else {
            GameSettings.shared.columns += Lets.columns.increment
        }
        columnsButton.set(title: Lets.columnsString)
    }
    
    func newGameButtonTapped() {
        delegate?.newGameTapped(for: self)
    }
}

protocol PlayViewControllerDelegate {
    func newGameTapped(for playViewController: PlayViewController)
}

extension UIButton {
    static func button(title: String, target: Any?, selector: Selector, font: Theme.Fonts) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.titleLabel?.font = font.font
        button.titleLabel?.tintColor = Theme.Colors.foreground.color
        button.backgroundColor = Theme.Colors.playButtonBackground.color
        button.layer.cornerRadius = 5
        return button
    }
    
    func set(title: String) {
        setTitle(title, for: .normal)
    }
}

    
