import CoreGraphics
import UIKit

class GameView: BaseView {
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

  required init?(coder _: NSCoder) { fatalError() }

  var colorsButtonClosure: (() -> Void)!

  @objc func colorsButtonTapped(_ button: UIButton) {
    button.isEnabled = false
    colorsButtonClosure()
  }

  var squaresButtonClosure: (() -> Void)!

  @objc func squaresButtonTapped(_ button: UIButton) {
    button.isEnabled = false
    squaresButtonClosure()
  }

  var numbersButtonClosure: (() -> Void)!

  @objc func numbersButtonTapped(_ button: UIButton) {
    button.isEnabled = false
    numbersButtonClosure()
  }

  func setupClosures(gameBrain: GameBrain?, quitGameClosure: (() -> Void)?) {
    colorsButtonClosure = gameBrain?.playerStatesColorsMatched
    squaresButtonClosure = gameBrain?.playerStatesSquaresMatched
    numbersButtonClosure = gameBrain?.playerStatesNumbersMatched

    self.quitGameClosure = quitGameClosure
  }

  var quitGameClosure: (() -> Void)!
  @objc func quitGameTapped() { quitGameClosure() }

  private func setupQuitButton() {
    quitGameButton = Button.quitGameButton(
      target: self,
      selector: #selector(quitGameTapped)
    )
    addSubview(quitGameButton)
  }

  private func setupMatchButtons(types: [GameType]) {
    buttons = [Button]()

    for type in types {
      var selector: Selector

      switch type {
      case .colors:
        selector = #selector(colorsButtonTapped(_:))
      case .numbers:
        selector = #selector(numbersButtonTapped(_:))
      case .squares:
        selector = #selector(squaresButtonTapped(_:))
      }

      let button = Button.matchButton(
        title: type.string,
        target: self,
        selector: selector
      )
      button.isEnabled = false

      buttons.append(button)
    }

    buttonStackView = StackView(
      arrangedSubviews: buttons,
      axis: .horizontal,
      spacing: 1,
      distribution: .fillEqually
    )
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

      let rowStackView = StackView(
        arrangedSubviews: columnViews,
        axis: .horizontal,
        spacing: 1,
        distribution: .fillEqually
      )
      rowStackViews.append(rowStackView)
    }
    mainStackView = StackView(
      arrangedSubviews: rowStackViews,
      axis: .vertical,
      spacing: 1,
      distribution: .fillEqually
    )
    addSubview(mainStackView)
    squareMatrix = SquareMatrix(
      rows: rows,
      columns: columns,
      elements: elements
    )
  }

  var rows = 0
  var columns = 0

  override func layoutSubviews() {
    setupConstraints()
  }

  private func setupConstraints() {
    var constraints = [NSLayoutConstraint]()

    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(
      mainStackView.centerYAnchor.constraint(
        equalTo: centerYAnchor,
        constant: -24
      )
    )
    constraints.append(
      mainStackView.widthAnchor.constraint(
        equalTo: mainStackView.heightAnchor,
        multiplier: CGFloat(squareMatrix.columns) / CGFloat(squareMatrix.rows)
      )
    )
    constraints.append(
      mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
    )

    let boardWidth = frame.width - 40
    let boardHeight = frame.height - (8 + 16 + 8 + 8)
      - quitGameButton.frame
      .height - buttonStackView.frame.height

    if boardHeight / boardWidth < CGFloat(rows) / CGFloat(columns) {
      constraints.append(
        mainStackView.heightAnchor.constraint(equalToConstant: boardHeight)
      )
    } else {
      constraints.append(
        mainStackView.leftAnchor.constraint(
          equalTo: layoutMarginsGuide.leftAnchor
        )
      )
      constraints.append(
        mainStackView.rightAnchor.constraint(
          equalTo: layoutMarginsGuide.rightAnchor
        )
      )
    }

    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(
      buttonStackView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -16
      )
    )
    constraints.append(
      buttonStackView.leftAnchor.constraint(
        equalTo: layoutMarginsGuide.leftAnchor
      )
    )
    constraints.append(
      buttonStackView.rightAnchor.constraint(
        equalTo: layoutMarginsGuide.rightAnchor
      )
    )
    constraints.append(
      buttonStackView.heightAnchor.constraint(
        equalToConstant: Lets.matchButtonHeight
      )
    )

    quitGameButton.translatesAutoresizingMaskIntoConstraints = false
    constraints.append(
      quitGameButton.topAnchor.constraint(
        equalTo: layoutMarginsGuide.topAnchor,
        constant: 8
      )
    )
    constraints.append(
      quitGameButton.rightAnchor.constraint(
        equalTo: layoutMarginsGuide.rightAnchor
      )
    )

    NSLayoutConstraint.activate(constraints)
  }

  func enableButtons() {
    buttons.forEach { $0.isEnabled = true }
  }
}
