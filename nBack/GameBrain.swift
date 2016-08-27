import Foundation
import UIKit

struct MatrixIndex: Equatable {
    var row: Int
    var column: Int
}

func ==(lhs: MatrixIndex, rhs: MatrixIndex) -> Bool {
    return (lhs.row == rhs.row && lhs.column == rhs.column)
}

func ==(lhs: (Int,Int), rhs: (Int,Int)) -> Bool {
    return true
}

enum Color {
    case yellow
    case green
    case orange
    case black
    case purple
    case red
    case brown
    case blue
    
    static func from(value: Int) -> Color {
        switch value {
        case 0: return .yellow
        case 1: return .green
        case 2: return .orange
        case 3: return .black
        case 4: return .purple
        case 5: return .red
        case 6: return .brown
        case 7: return .blue
        default: fatalError()
        }
    }
    
    var color: UIColor {
        switch self {
        case .yellow: return UIColor.yellow
        case .green: return UIColor.green
        case .orange: return UIColor.orange
        case .black: return UIColor.black
        case .purple: return UIColor.purple
        case .red: return UIColor.red
        case .brown: return UIColor.brown
        case .blue: return UIColor.blue
        }
    }
}

class GameBrain: HasContext {
    
    var delegate: GameBrainDelegate
    
    var timer: Timer?
    var squareMatrix: SquareMatrix
    var settings: GameSettings { return GameSettings.shared }
    
    init(squareMatrix: SquareMatrix, delegate: GameBrainDelegate) {
        self.squareMatrix = squareMatrix
        self.delegate = delegate
    }
    
    func generateSequences() {
        for type in settings.types {
            switch type {
            case .squares:
                squareOrder = (1...settings.numberOfTurns).map { _ in MatrixIndex(row: Utilities.random(max: settings.rows - 1), column: Utilities.random(max: settings.columns - 1)) }
                playerSquareAnswers = [Bool](repeating: false, count: settings.numberOfTurns - settings.level)
            case .numbers:
                numberOrder = (1...settings.numberOfTurns).map { _ in Utilities.random(max: 8) + 1 }
                playerNumberAnswers = [Bool](repeating: false, count: settings.numberOfTurns - settings.level)
            case .colors:
                colorOrder = (1...settings.numberOfTurns).map { _ in Utilities.random(max: 7) }.map { Color.from(value: $0).color }
                playerColorAnswers = [Bool](repeating: false, count: settings.numberOfTurns - settings.level)
            }
        }
    }
    
    func speakNextNumber() {
        
    }
    
    func highlightAndColorNextSquare() {
        var index: MatrixIndex
        var color: UIColor
        switch (squareOrder, colorOrder) {
        case (nil,nil): return
        case (let squareOrder, nil):
            index = squareOrder![turnCount]
            color = Theme.Colors.highlightedSquare.color
        case (nil, let colorOrder):
            index = MatrixIndex(row: 0, column: 0)
            color = colorOrder![turnCount]
        case (let squareOrder, let colorOrder):
            index = squareOrder![turnCount]
            color = colorOrder![turnCount]
        }
        squareMatrix.color(row: index.row, column: index.column, color: color)
    }
    
    
    func playerStatesNumbersMatched() { playerNumberAnswers![turnCount - 1] = true }
    func playerStatesSquaresMatched() { playerSquareAnswers![turnCount - 1] = true }
    func playerStatesColorsMatched() { playerColorAnswers![turnCount - 1] = true }
    
    func start() {
        generateSequences()
        timer = Timer.scheduledTimer(withTimeInterval: settings.timeBetweenTurns, repeats: true) { timer in
            if self.settings.types.contains(.numbers) {
                self.speakNextNumber()
            }
            if self.settings.types.contains(.squares) || self.settings.types.contains(.colors) {
                self.highlightAndColorNextSquare()
            }
            if self.turnCount == self.settings.level {
                self.delegate.enableButtons()
            }
            self.turnCount += 1
            if self.turnCount == self.settings.numberOfTurns {
                timer.invalidate()
                self.finish()
                return
            }
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
                switch type {
                case .squares: result.backTypes.insert(self.tally(order: self.squareOrder, playerAnswers: self.playerSquareAnswers, for: .squares))
                case .numbers: result.backTypes.insert(self.tally(order: self.numberOrder, playerAnswers: self.playerNumberAnswers, for: .numbers))
                case .colors: result.backTypes.insert(self.tally(order: self.colorOrder, playerAnswers: self.playerColorAnswers, for: .colors))
                }
            }
            do {
                try self.context.save()
            } catch {
                Utilities.show(error: error)
            }
            self.delegate.gameBrainDidFinish(with: result)
        }
    }
    
    func tally<T: Equatable>(order: [T], playerAnswers: [Bool], for type: GameType) -> BackTypeResult {
        var correctAnswers = [Bool]()
        
        for i in settings.level..<order.count {
            if order[i] == order[i-2] {
                correctAnswers.append(true)
            } else {
                correctAnswers.append(false)
            }
        }
        
        var falseFalse = 0
        var falseTrue = 0
        var trueFalse = 0
        var trueTrue = 0
        
        var results = zip(playerAnswers, correctAnswers).map { player,correct -> Bool in
            switch (player,correct) {
            case (false,false): falseFalse += 1; return true
            case (false,true): falseTrue += 1; return false
            case (true,false): trueFalse += 1; return false
            case (true,true): trueTrue += 1; return true
            }
        }
        var result: BackTypeResult? = nil
        context.performAndWait {
            result = BackTypeResult(context: self.context)
            result?.correct = Int16(falseFalse + trueTrue)
            result?.incorrect = Int16(falseTrue + trueFalse)
            result?.matches = Int16(falseTrue + trueTrue)
            result?.backType = Int16(type.value)
            do {
                try self.context.save()
            } catch {
                Utilities.show(error: error)
            }
        }
        return result!
    }
}

protocol GameBrainDelegate {
    func gameBrainDidFinish(with result: GameResult)
    func enableButtons()
}
