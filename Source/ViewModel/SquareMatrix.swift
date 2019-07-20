import UIKit

class SquareMatrix {
    var rows: Int
    var columns: Int
    private var elements: [SquareView]

    init(rows: Int, columns: Int, elements: [SquareView]) {
        self.rows = rows
        self.columns = columns
        self.elements = elements
    }

    subscript(row: Int, column: Int) -> SquareView {
        return elements[row * columns + column]
    }

    func color(row: Int, column: Int, color: UIColor) {
        let square = self[row, column]
        square.backgroundColor = color
        let deadline: DispatchTime = DispatchTime.now() + GameSettings.shared.squareHighlightTime.nanoseconds
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            square.backgroundColor = Theme.Colors.normalSquare
        }
    }
}
