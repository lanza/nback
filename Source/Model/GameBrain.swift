import Foundation
import UIKit

class GameBrain {
   
   init(delegate: GameBrainDelegate) {
      self.delegate = delegate
   }
   
   unowned var delegate: GameBrainDelegate
   
   var timer: Timer?
   let sequenceLength = GameSettings.numberOfTurns + GameSettings.level
   
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
   
   func generateSequences() {
      let sequenceGenerator = SequenceGenerator()
      
      if GameSettings.types.contains(.squares) {
         generatedSquareOrder = sequenceGenerator.generateSquareSequence()
         playerSquareAnswers = sequenceGenerator.createArrayOfFalses()
      }
      if GameSettings.types.contains(.numbers) {
         generatedNumberOrder = sequenceGenerator.generateNumberSequence()
         playerNumberAnswers = sequenceGenerator.createArrayOfFalses()
      }
      if GameSettings.types.contains(.colors) {
         generatedColorOrder = sequenceGenerator.generateColorSequence()
         playerColorAnswers = sequenceGenerator.createArrayOfFalses()
      }
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
      delegate.colorGameView(row: index.row, column: index.column, color: color)
   }
   
   func playerStatesNumbersMatched() { playerNumberAnswers![turnCount - 1 - GameSettings.level] = true }
   func playerStatesSquaresMatched() { playerSquareAnswers![turnCount - 1 - GameSettings.level] = true }
   func playerStatesColorsMatched() { playerColorAnswers![turnCount - 1 - GameSettings.level] = true }
   

   
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
   
   func quit() {
      timer?.invalidate()
   }
}

protocol GameBrainDelegate: class {
   func gameBrainDidFinish(with result: GameResultRealm)
   func enableButtons()
   func colorGameView(row: Int, column: Int, color: UIColor)
}
