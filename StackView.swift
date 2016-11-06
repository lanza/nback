import UIKit

class StackView: UIStackView {
    init(arrangedSubviews: [UIView], axis: UILayoutConstraintAxis, spacing: CGFloat, distribution: UIStackViewDistribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder: NSCoder) {
        fatalError(#function + " not implemented.")
    }
}
