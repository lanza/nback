import UIKit

class DayTableViewController: ViewController {

    var day: Day!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Lets.cellLabelDateFormatter.string(from: day.date)
        let nib = UINib(nibName: "GameResultCell", bundle: Bundle.main)
    }
}


