import UIKit

class GameResultCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var gameNumber: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var turnsLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    

}

extension GameResultCell: ConfigurableCell {
    func configure(for object: GameResultRealm, indexPath: IndexPath) {
        gameNumber.text = String(indexPath.row + 1)
        levelLabel.text = Lets.nBackTypeCountString(for: object) + " \(object.level)-back " + Lets.nBackTypeListString(for: object)
        turnsLabel.text = String(object.numberOfTurns)
        correctLabel.text = String(object.totalCorrect)
        incorrectLabel.text = String(object.totalIncorrect)
    }
}