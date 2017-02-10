import UIKit

class DayTableViewCellLabel: UILabel {
    init() {
        super.init(frame: CGRect())
        font = Theme.Fonts.smallerLabel
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
