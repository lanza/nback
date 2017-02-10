import UIKit

class HeaderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Theme.Colors.primary
        dateLabel.textColor = Theme.Colors.secondary
    }
    @IBOutlet weak var dateLabel: UILabel!
}
