import UIKit

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
