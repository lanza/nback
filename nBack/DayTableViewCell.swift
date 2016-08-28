import UIKit

class DayTableViewCell: TableViewCell {
    
}

extension DayTableViewCell: ConfigurableCell {
    func configure(for object: GameResult) {
        textLabel?.text = Lets.cellLabelDateFormatter.string(from: object.date)
    }
}
