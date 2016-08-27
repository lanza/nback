import Foundation
import UIKit


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

class GameBrain {
    
    var timer: Timer?
    var squareMatrix: SquareMatrix
    var settings: GameSettings { return GameSettings.shared }
    
    init(squareMatrix: SquareMatrix) { self.squareMatrix = squareMatrix }
    
    func generateSequences() {
        for type in settings.types {
            switch type {
            case .squares:
                squareOrder = (1...settings.numberOfTurns).map { _ in (Utilities.random(max: settings.rows - 1), Utilities.random(max: settings.columns - 1)) }
            case .numbers:
                numberOrder = (1...settings.numberOfTurns).map { _ in Utilities.random(max: 8) + 1 }
            case .colors:
                colorOrder = (1...settings.numberOfTurns).map { _ in Utilities.random(max: 7) }.map { Color.from(value: $0) }
            }
        }
    }
    
    func speakNextNumber() {
        
    }
    
    func highlightAndColorNextSquare() {
        var row: Int
        var column: Int
        var color: UIColor
        switch (squareOrder, colorOrder) {
        case (nil,nil): return
        case (let squareOrder, nil):
            (row,column) = squareOrder![turnCount]
            color = Theme.Colors.highlightedSquare.color
        case (nil, let colorOrder):
            (row,column) = (0,0)
            color = colorOrder![turnCount].color
        case (let squareOrder, let colorOrder):
            (row,column) = squareOrder![turnCount]
            color = colorOrder![turnCount].color
        }
        squareMatrix.color(row: row, column: column, color: color)
    }
    
    
    func playerStatesNumbersMatched() {}
    func playerStatesSquaresMatched() {}
    func playerStatesColorsMatched() {}
    
    func start() {
        self.timer = Timer.init(fire: Date(), interval: settings.timeBetweenTurns, repeats: true) { timer in
            if self.settings.types.contains(.numbers) {
                self.speakNextNumber()
            }
            if self.settings.types.contains(.squares) || self.settings.types.contains(.colors) {
                self.highlightAndColorNextSquare()
            }
            self.turnCount += 1
            if self.turnCount == self.settings.numberOfTurns {
                timer.invalidate()
                return
            }
        }
    }
    
    var turnCount = 0
    var squareOrder: [(Int,Int)]?
    var numberOrder: [Int]?
    var colorOrder: [Color]?
    
    
}
