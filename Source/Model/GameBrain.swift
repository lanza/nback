import Foundation
import UIKit

struct SequenceGenerator {
   
}

class GameBrain {
   
   unowned var delegate: GameBrainDelegate
   
   var timer: Timer?
   var squareMatrix: SquareMatrix
   
   init(squareMatrix: SquareMatrix, delegate: GameBrainDelegate) {
      self.squareMatrix = squareMatrix
      self.delegate = delegate
   }
   
   func quit() {
      timer?.invalidate()
   }
   
   var sequenceLength: Int { return GameSettings.numberOfTurns + GameSettings.level }
   func generateSequences() {
      if GameSettings.types.contains(.squares) {
         generatedSquareOrder = generateSquareSequence()
         playerSquareAnswers = createArrayOfFalses()
      }
      if GameSettings.types.contains(.numbers) {
         generatedNumberOrder = generateNumberSequence()
         playerNumberAnswers = createArrayOfFalses()
      }
      if GameSettings.types.contains(.colors) {
         generatedColorOrder = generateColorSequence()
         playerColorAnswers = createArrayOfFalses()
      }
   }
   func createArrayOfFalses() -> [Bool] {
      return Array<Bool>(repeating: false, count: GameSettings.numberOfTurns)
   }
   func generateSquareSequence() -> [MatrixIndex] {
      return (1...sequenceLength).map { _ in MatrixIndex(row: Utilities.random(range: 0..<GameSettings.rows), column: Utilities.random(range: 0..<GameSettings.columns)) }
   }
   func generateNumberSequence() -> [Int] {
      return (1...sequenceLength).map { _ in Utilities.random(range: 1...9) }
   }
   func generateColorSequence() -> [UIColor] {
      return (1...sequenceLength).map { _ in Utilities.random(range: 0...7) }.map { Color.from(value: $0).color }
   }
   
   func speakNextNumber() {
      let numberToSay = generatedNumberOrder[turnCount]
      SpeechSynthesizer.speak(number: numberToSay)
   }
   
   func highlightAndColorNextSquare() {
      var index: MatrixIndex
      var color: UIColor
      switch (generatedSquareOrder, generatedColorOrder) {
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
   
   var generatedSquareOrder: [MatrixIndex]!
   var generatedNumberOrder: [Int]!
   var generatedColorOrder: [UIColor]!
   
   var playerSquareAnswers: [Bool]!
   var playerNumberAnswers: [Bool]!
   var playerColorAnswers: [Bool]!
   
   func finish() {
      let result = calculateGameResult()
      setLastGameStrings(for: result)
      delegate.gameBrainDidFinish(with: result)
   }
   
   func setLastGameStrings(for result: GameResultRealm) {
      let defaults = UserDefaults.standard
      defaults[.lastScoreString] = Lets.scoreString(for: result)
      defaults[.lastResultString] = Lets.resultString(for: result)
   }
   
   func calculateGameResult() -> GameResultRealm {
      let result = GameResultRealm.new(columns: GameSettings.columns, rows: GameSettings.rows, level: GameSettings.level, numberOfTurns: GameSettings.numberOfTurns, secondsBetweenTurns: GameSettings.secondsBetweenTurns, squareHighlightTime: GameSettings.squareHighlightTime)
      
      GameSettings.types.map(tallyTypeResult).forEach {
         result.add(typeResult: $0)
      }
      
      return result
   }
   func tallyTypeResult(for type: NBackType) -> TypeResultRealm {
      switch type {
      case .squares:
         return tallyTypeResult(order: generatedSquareOrder, playerAnswers: playerSquareAnswers, for: .squares)
      case .numbers:
         return tallyTypeResult(order: generatedNumberOrder, playerAnswers: playerNumberAnswers, for: .numbers)
      case .colors:
         return tallyTypeResult(order: generatedColorOrder, playerAnswers: playerColorAnswers, for: .colors)
      }
   }
   func tallyTypeResult<T: Equatable>(order: [T], playerAnswers: [Bool], for type: NBackType) -> TypeResultRealm {
      let correctAnswers = calculateCorrectAnswers(order: order)
      let score = Score.tally(correctAnswers: correctAnswers, playerAnswers: playerAnswers)
      return TypeResultRealm.new(score: score, nBackType: type)
   }
   
   func calculateCorrectAnswers<T: Equatable>(order: [T]) -> [Bool] {
      var correctAnswers: [Bool] = []
      for i in GameSettings.level..<order.count {
         correctAnswers.append(order[i] == order[i - GameSettings.level])
      }
      return correctAnswers
   }
   
}

protocol GameBrainDelegate: class {
   func gameBrainDidFinish(with result: GameResultRealm)
   func enableButtons()
}
