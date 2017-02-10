import UIKit

class Label: UILabel {
    init() {
        super.init(frame: CGRect())
        font = Theme.Fonts.label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
