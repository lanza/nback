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
   
   subscript (row: Int, column: Int) -> SquareView {
      return elements[row * columns + column]
   }
   
}

struct MatrixIndex: Equatable {
   var row: Int
   var column: Int
   
   static func ==(lhs: MatrixIndex, rhs: MatrixIndex) -> Bool {
      return (lhs.row == rhs.row && lhs.column == rhs.column)
   }
}
