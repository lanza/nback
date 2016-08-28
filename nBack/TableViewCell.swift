import UIKit

class TableViewCell: UITableViewCell, ConfigurableCell {
    func configure(for object: Day) {
        textLabel?.text = "\(object.date)"
    }
}
