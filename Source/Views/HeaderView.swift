import UIKit

class HeaderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Theme.Colors.white
        dateLabel.textColor = Theme.Colors.secondary
    }
    @IBOutlet weak var dateLabel: UILabel!
}
