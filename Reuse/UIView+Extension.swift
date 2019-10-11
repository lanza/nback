import UIKit

extension UIView {
  public func setBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
    layer.borderColor = color.cgColor
    layer.borderWidth = width
    layer.cornerRadius = radius
  }

  public func setShadow(
    offsetWidth: CGFloat,
    offsetHeight: CGFloat,
    radius: CGFloat,
    opacity: Float,
    color: UIColor
  ) {
    layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    layer.shadowColor = color.cgColor
  }
}
