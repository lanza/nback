import Foundation
import UIKit

struct SequenceGenerator {
   let sequenceLength = GameSettings.numberOfTurns + GameSettings.level
   var base: CountableClosedRange<Int> { return (1...sequenceLength) }
   
   func generateSquareSequence() -> [MatrixIndex] {
      return (1...sequenceLength).map { _ in MatrixIndex(row: Utilities.random(range: 0..<GameSettings.rows), column: Utilities.random(range: 0..<GameSettings.columns)) }
   }
   func generateNumberSequence() -> [Int] {
      return (1...sequenceLength).map { _ in Utilities.random(range: 1...9) }
   }
   func generateColorSequence() -> [UIColor] {
      return (1...sequenceLength).map { _ in Utilities.random(range: 0...7) }.map { Color.from(value: $0).color }
   }
   func createArrayOfFalses() -> [Bool] {
      return Array<Bool>(repeating: false, count: GameSettings.numberOfTurns)
   }
}
