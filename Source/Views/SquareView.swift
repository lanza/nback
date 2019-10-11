import UIKit

class SquareView: UIView {
  init() {
    super.init(frame: CGRect())
    backgroundColor = Theme.Colors.normalSquare
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
