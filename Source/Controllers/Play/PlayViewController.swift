import UIKit

class PlayView: UIView {
  init() {
    super.init(frame: CGRect())
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}

protocol PlayViewControllerDelegate: class {
  func newGameTapped()
}

class PlayViewController: ViewController, HasContext {
  
  weak var delegate: PlayViewControllerDelegate!
  
  var lastGameResult: GameResult?
  
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
      lastGameLabel.text = "Last Game \n" + lastResultString + "\n" + lastScoreString
    }
  }
    
    func playGameButtonTapped(button: UIButton) {
        delegate.newGameTapped()
    }
  override func loadView() {
    view = View()
    
    lastGameLabel = Label()
    lastGameLabel.numberOfLines = 0
    lastGameLabel.font = Theme.Fonts.lastGameLabel
    lastGameLabel.textColor = Theme.Colors.secondary
    lastGameLabel.layer.cornerRadius = 5
    lastGameLabel.clipsToBounds = true
    
    secondsBetweenTurnsButton = UIButton.button(title: Lets.secondsBetweenTurnsString, target: self, selector: #selector(secondsBetweenTurnsButtonTapped), font: Theme.Fonts.playLabels)
    let secondsBetweenTurnsStackView = StackView(arrangedSubviews: [secondsBetweenTurnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
    
    squareButton = UIButton.button(title: Lets.squaresString, target: self, selector: #selector(squareButtonTapped), font: Theme.Fonts.playLabels )
    squareButton.titleLabel?.numberOfLines = 2
    squareButton.titleLabel?.textAlignment = .center
    numberButton = UIButton.button(title: Lets.numbersString, target: self, selector: #selector(numberButtonTapped), font: Theme.Fonts.playLabels)
    numberButton.titleLabel?.numberOfLines = 2
    numberButton.titleLabel?.textAlignment = .center
    colorButton = UIButton.button(title: Lets.colorsString, target: self, selector: #selector(colorButtonTapped), font: Theme.Fonts.playLabels)
    colorButton.titleLabel?.numberOfLines = 2
    colorButton.titleLabel?.textAlignment = .center
    
    levelButton = UIButton.button(title: Lets.levelString, target: self, selector: #selector(levelButtonTapped), font: Theme.Fonts.playLabels)
    turnsButton = UIButton.button(title: Lets.turnsString, target: self, selector: #selector(turnsButtonTapped), font: Theme.Fonts.playLabels)
    let levelAndTurnsStackView = StackView(arrangedSubviews: [levelButton, turnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
    
    let squaresIsOn = GameSettings.shared.types.contains(.squares)
    rowsButton = UIButton.button(title: Lets.rowsString, target: self, selector: #selector(rowsButtonTapped), font: Theme.Fonts.playLabels)
    rowsButton.isEnabled = squaresIsOn
    columnsButton = UIButton.button(title: Lets.columnsString, target: self, selector: #selector(columnsButtonTapped), font: Theme.Fonts.playLabels)
    columnsButton.isEnabled = squaresIsOn
    let rowsAndColumnsStackView = StackView(arrangedSubviews: [rowsButton,columnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
    
    playGameButton = UIButton.button(title: Lets.playl10n, target: self, selector: nil, font: Theme.Fonts.playLabels)
    playGameButton.addTarget(self, action: #selector(playGameButtonTapped(button:)), for: UIControl.Event.touchUpInside)
    playGameButton.backgroundColor = Theme.Colors.playButtonBackground
    playGameButton.setTitleColor(Theme.Colors.playButtonFont, for: UIControl.State())
    playGameButton.layer.cornerRadius = 5
    let playGameButtonStackView = StackView(arrangedSubviews: [playGameButton], axis: .horizontal, spacing: 0, distribution: .fillEqually)
    
    var views: [UIView]
    
    if UIScreen.main.bounds.height > 0 {
      views = [secondsBetweenTurnsStackView, squareButton, numberButton, colorButton, levelAndTurnsStackView,rowsAndColumnsStackView,playGameButtonStackView]
    } else {
      let typeButtonsStackView = StackView(arrangedSubviews: [squareButton,numberButton,colorButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
      views = [secondsBetweenTurnsStackView, typeButtonsStackView, levelAndTurnsStackView, rowsAndColumnsStackView, playGameButtonStackView]
    }
    
    let preStackView = StackView(arrangedSubviews: views, axis: .vertical, spacing: 8, distribution: .fillEqually)
    let stackView = StackView(arrangedSubviews: [lastGameLabel,preStackView], axis: .vertical, spacing: 8, distribution: .fill)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    
    var constraints = [NSLayoutConstraint]()
    
    let centerConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    centerConstraint.priority = UILayoutPriority(rawValue: 100)
    constraints.append(centerConstraint)
    constraints.append(stackView.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor, constant: 16))
    constraints.append(stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomLayoutGuide.topAnchor, constant: -16))
    constraints.append(stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor))
    constraints.append(stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor))
    
    NSLayoutConstraint.activate(constraints)
    view.setNeedsLayout()
  }
  
  @objc func secondsBetweenTurnsButtonTapped() {
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
  @objc func numberButtonTapped() {
    typeButtonTapped(type: .numbers, button: numberButton)
    numberButton.set(title: Lets.numbersString)
  }
  @objc func squareButtonTapped() {
    typeButtonTapped(type: .squares, button: squareButton)
    squareButton.set(title: Lets.squaresString)
    let isOn = GameSettings.shared.types.contains(.squares)
    rowsButton.isEnabled = isOn
    columnsButton.isEnabled = isOn
  }
  @objc func colorButtonTapped() {
    typeButtonTapped(type: .colors, button: colorButton)
    colorButton.set(title: Lets.colorsString)
  }
  
  @objc func levelButtonTapped() {
    if GameSettings.shared.level == Lets.levels.max {
      GameSettings.shared.level = Lets.levels.min
    } else {
      GameSettings.shared.level += Lets.levels.increment
    }
    levelButton.set(title: Lets.levelString)
  }
  @objc func turnsButtonTapped() {
    if GameSettings.shared.numberOfTurns == Lets.turns.max {
      GameSettings.shared.numberOfTurns = Lets.turns.min
    } else {
      GameSettings.shared.numberOfTurns += Lets.turns.increment
    }
    turnsButton.set(title: Lets.turnsString)
  }
  
  @objc func rowsButtonTapped() {
    if GameSettings.shared.rows == Lets.rows.max {
      GameSettings.shared.rows = Lets.rows.min
    } else {
      GameSettings.shared.rows += Lets.rows.increment
    }
    rowsButton.set(title: Lets.rowsString)
  }
  
  @objc func columnsButtonTapped() {
    if GameSettings.shared.columns == Lets.columns.max {
      GameSettings.shared.columns = Lets.columns.min
    } else {
      GameSettings.shared.columns += Lets.columns.increment
    }
    columnsButton.set(title: Lets.columnsString)
  }
}





