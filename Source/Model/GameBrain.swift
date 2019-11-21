import Foundation
import UIKit

struct MatrixIndex: Equatable {
  var row: Int
  var column: Int
}

func == (lhs: MatrixIndex, rhs: MatrixIndex) -> Bool {
  return (lhs.row == rhs.row && lhs.column == rhs.column)
}

class GameBrain: HasContext {
  var speechSynthesizer: SpeechSynthesizer
  var delegate: GameBrainDelegate

  var timer: Timer?
  var squareMatrix: SquareMatrix
  var settings: GameSettings { return GameSettings.shared }

  init(squareMatrix: SquareMatrix, delegate: GameBrainDelegate) {
    speechSynthesizer = SpeechSynthesizer()
    self.squareMatrix = squareMatrix
    self.delegate = delegate
  }

  func quit() {
    timer?.invalidate()
  }

  var sequenceLength: Int { return settings.numberOfTurns + settings.level }

  func generateSequences() {
    for type in settings.types {
      switch type {
      case .squares:
        squareOrder = (1...sequenceLength).map { _ in
          MatrixIndex(
            row: Utilities.random(range: 0..<settings.rows),
            column: Utilities.random(range: 0..<settings.columns)
          )
        }
        playerSquareAnswers = [Bool](
          repeating: false,
          count: sequenceLength - settings.level
        )
      case .numbers:
        numberOrder = (1...sequenceLength).map { _ in
          Utilities.random(range: 1...9)
        }
        playerNumberAnswers = [Bool](
          repeating: false,
          count: sequenceLength - settings.level
        )
      case .colors:
        colorOrder = (1...sequenceLength).map { _ in
          Utilities.random(range: 0...7)
        }.map { Color.from(value: $0).color }
        playerColorAnswers = [Bool](
          repeating: false,
          count: sequenceLength - settings.level
        )
      }
    }
  }

  func speakNextNumber() {
    let numberToSay = numberOrder[turnCount]
    speechSynthesizer.speak(number: numberToSay)
  }

  func highlightAndColorNextSquare() {
    var index: MatrixIndex
    var color: UIColor
    switch (squareOrder, colorOrder) {
    case (nil, nil): return
    case (let squareOrder, nil):
      index = squareOrder![turnCount]
      color = Theme.Colors.highlightedSquare
    case (nil, let colorOrder):
      index = MatrixIndex(row: 0, column: 0)
      color = colorOrder![turnCount]
    case let (squareOrder, colorOrder):
      index = squareOrder![turnCount]
      color = colorOrder![turnCount]
    }
    squareMatrix.color(row: index.row, column: index.column, color: color)
  }

  func playerStatesNumbersMatched() {
    playerNumberAnswers![turnCount - 1 - settings.level] = true
  }

  func playerStatesSquaresMatched() {
    playerSquareAnswers![turnCount - 1 - settings.level] = true
  }

  func playerStatesColorsMatched() {
    playerColorAnswers![turnCount - 1 - settings.level] = true
  }

  func start() {
    generateSequences()
    timer = Timer.scheduledTimer(
      withTimeInterval: settings.secondsBetweenTurns,
      repeats: true
    ) { timer in

      guard self.turnCount < self.sequenceLength else {
        timer.invalidate()
        self.finish()
        return
      }

      if self.settings.types.contains(.numbers) {
        self.speakNextNumber()
      }
      if self.settings.types.contains(.squares)
        || self.settings.types.contains(
          .colors
        )
      {
        self.highlightAndColorNextSquare()
      }
      if self.turnCount >= self.settings.level {
        self.delegate.enableButtons()
      }
      self.turnCount += 1
    }
  }

  var turnCount = 0

  var squareOrder: [MatrixIndex]!
  var numberOrder: [Int]!
  var colorOrder: [UIColor]!

  var playerSquareAnswers: [Bool]!
  var playerNumberAnswers: [Bool]!
  var playerColorAnswers: [Bool]!

  func finish() {
    context.performAndWait {
      let result = GameResult(context: self.context)
      result.initialize()
      for type in self.settings.types {
        var tally: TypeResult
        switch type {
        case .squares:
          tally = self.tally(
            order: self.squareOrder,
            playerAnswers: self.playerSquareAnswers,
            for: .squares
          )
        case .numbers:
          tally = self.tally(
            order: self.numberOrder,
            playerAnswers: self.playerNumberAnswers,
            for: .numbers
          )
        case .colors:
          tally = self.tally(
            order: self.colorOrder,
            playerAnswers: self.playerColorAnswers,
            for: .colors
          )
        }
        result.types.insert(tally)
      }
      self.context.save { Utilities.show(error: $0) }

      let defaults = UserDefaults.standard

      defaults.set(Lets.scoreString(for: result), forKey: Lets.lastScoreString)
      defaults.set(
        Lets.resultString(for: result),
        forKey: Lets.lastResultString
      )

      self.delegate.gameBrainDidFinish(with: result)
    }
  }

  func tally<T: Equatable>(
    order: [T],
    playerAnswers: [Bool],
    for type: GameType
  ) -> TypeResult {
    var correctAnswers = [Bool]()

    for i in settings.level..<order.count {
      correctAnswers.append(order[i] == order[i - settings.level])
    }

    var falseFalse: Int16 = 0
    var falseTrue: Int16 = 0
    var trueFalse: Int16 = 0
    var trueTrue: Int16 = 0

    _ = zip(playerAnswers, correctAnswers).map { player, correct -> Bool in
      switch (player, correct) {
      case (false, false):
        falseFalse += 1
        return true
      case (false, true):
        falseTrue += 1
        return false
      case (true, false):
        trueFalse += 1
        return false
      case (true, true):
        trueTrue += 1
        return true
      }
    }

    let result = TypeResult(context: context)

    result.correct = falseFalse + trueTrue
    result.incorrect = falseTrue + trueFalse
    result.matches = falseTrue + trueTrue
    result.type = type

    result.falseFalse = falseFalse
    result.falseTrue = falseTrue
    result.trueFalse = trueFalse
    result.trueTrue = trueTrue

    return result
  }
}

protocol GameBrainDelegate {
  func gameBrainDidFinish(with result: GameResult)
  func enableButtons()
}
