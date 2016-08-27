import Foundation

struct GameBrain {
    
    var squareMatrix: SquareMatrix
    var settings: GameSettings { return GameSettings.shared }
    
    func squaresButtonTapped() {}
    func numbersButtonTapped() {}
    func colorsButtonTapped() {}
}

