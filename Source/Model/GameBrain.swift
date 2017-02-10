import Foundation
import UIKit



func ==(lhs: MatrixIndex, rhs: MatrixIndex) -> Bool {
  return (lhs.row == rhs.row && lhs.column == rhs.column)
}



class GameBrain {
  
  var speechSynthesizer: SpeechSynthesizer
  var delegate: GameBrainDelegate
  
  var timer: Timer?
  var squareMatrix: SquareMatrix
  
  init(squareMatrix: SquareMatrix, delegate: GameBrainDelegate) {
    self.speechSynthesizer = SpeechSynthesizer()
    self.squareMatrix = squareMatrix
    self.delegate = delegate
  }
  
  func quit() {
    timer?.invalidate()
  }
  
  var sequenceLength: Int { return GameSettings.numberOfTurns + GameSettings.level }
  
  func generateSequences() {
    for type in GameSettings.types {
      switch type {
      case .squares:
        squareOrder = (1...sequenceLength).map { _ in MatrixIndex(row: Utilities.random(range: 0..<GameSettings.rows), column: Utilities.random(range: 0..<GameSettings.columns)) }
        playerSquareAnswers = [Bool](repeating: false, count: sequenceLength - GameSettings.level)
      case .numbers:
        numberOrder = (1...sequenceLength).map { _ in Utilities.random(range: 1...9) }
        playerNumberAnswers = [Bool](repeating: false, count: sequenceLength - GameSettings.level)
      case .colors:
        colorOrder = (1...sequenceLength).map { _ in Utilities.random(range: 0...7) }.map { Color.from(value: $0).color }
        playerColorAnswers = [Bool](repeating: false, count: sequenceLength - GameSettings.level)
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
    case (nil,nil): return
    case (let squareOrder, nil):
      index = squareOrder![turnCount]
      color = Theme.Colors.highlightedSquare
    case (nil, let colorOrder):
      index = MatrixIndex(row: 0, column: 0)
      color = colorOrder![turnCount]
    case (let squareOrder, let colorOrder):
      index = squareOrder![turnCount]
      color = colorOrder![turnCount]
    }
    squareMatrix.color(row: index.row, column: index.column, color: color)
  }
  
  func playerStatesNumbersMatched() { playerNumberAnswers![turnCount - 1 - GameSettings.level] = true }
  func playerStatesSquaresMatched() { playerSquareAnswers![turnCount - 1 - GameSettings.level] = true }
  func playerStatesColorsMatched() { playerColorAnswers![turnCount - 1 - GameSettings.level] = true }
  
  func start() {
    generateSequences()
    timer = Timer.scheduledTimer(withTimeInterval: GameSettings.secondsBetweenTurns, repeats: true) { timer in
      
      guard self.turnCount < self.sequenceLength else {
        timer.invalidate()
        self.finish()
        return
      }
      
      if GameSettings.types.contains(.numbers) {
        self.speakNextNumber()
      }
      if GameSettings.types.contains(.squares) || GameSettings.types.contains(.colors) {
        self.highlightAndColorNextSquare()
      }
      if self.turnCount >= GameSettings.level {
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
    
    let result = GameResultRealm.new(columns: GameSettings.columns, rows: GameSettings.rows, level: GameSettings.level, numberOfTurns: GameSettings.numberOfTurns, secondsBetweenTurns: GameSettings.secondsBetweenTurns, squareHighlightTime: GameSettings.squareHighlightTime)
    
    for type in GameSettings.types {
      switch type {
      case .squares:
        tally(order: self.squareOrder, playerAnswers: self.playerSquareAnswers, for: .squares, result: result)
      case .numbers:
        tally(order: self.numberOrder, playerAnswers: self.playerNumberAnswers, for: .numbers, result: result)
      case .colors:
        tally(order: self.colorOrder, playerAnswers: self.playerColorAnswers, for: .colors, result: result)
      }
      
      let defaults = UserDefaults.standard
      defaults[.lastScoreString] = Lets.scoreString(for: result)
      defaults[.lastResultString] = Lets.resultString(for: result)
      self.delegate.gameBrainDidFinish(with: result)
    }
  }
  
  func tally<T: Equatable>(order: [T], playerAnswers: [Bool], for type: NBackType, result: GameResultRealm) {
    var correctAnswers = [Bool]()
    
    for i in GameSettings.level..<order.count {
      correctAnswers.append(order[i] == order[i - GameSettings.level])
    }
    
    var falseFalse = 0
    var falseTrue = 0
    var trueFalse = 0
    var trueTrue = 0
    
    _ = zip(playerAnswers, correctAnswers).map { player,correct -> Bool in
      switch (player,correct) {
      case (false,false): falseFalse += 1; return true
      case (false,true): falseTrue += 1; return false
      case (true,false): trueFalse += 1; return false
      case (true,true): trueTrue += 1; return true
      }
    }
    
    let correct = falseFalse + trueTrue
    let incorrect = falseTrue + trueFalse
    let matches = falseTrue + trueTrue
    
     _ = TypeResultRealm.new(correct: correct, incorrect: incorrect, matches: matches, falseFalse: falseFalse, falseTrue: falseTrue, trueFalse: trueFalse, trueTrue: trueTrue, nBackType: type, game: result)
  }
}

protocol GameBrainDelegate {
  func gameBrainDidFinish(with result: GameResultRealm)
  func enableButtons()
}
