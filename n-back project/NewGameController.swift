import UIKit

class NewGameController: UIViewController {
    
    var defaults = UserDefaults.standard()
    var brain: NBackBrain!
    
    @IBOutlet weak var lastPlayLabel: UILabel!
    @IBOutlet weak var turnsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    
    var currentBack = 0
    var currentTurns = 0
    
    @IBAction func turnsButtonPushed() {
        if currentTurns > 24 {
            currentTurns = 5
        } else {
            currentTurns += 1
        }
        
        turnsButton.setTitle("\(currentTurns) turns", for: UIControlState())
    }
    @IBAction func backButtonPushed() {
        if currentBack > 6 {
            currentBack = 1
        } else {
            currentBack += 1
        }
        
        backButton.setTitle("\(currentBack)-back", for: UIControlState())
    }
    @IBAction func audioButtonPushed() {
        var backTypes = (defaults.array(forKey: Constants.backTypesKey) as! [Int]).map { BackType(rawValue: $0)! }
        
        if let index = backTypes.index(of: .numbers) {
            backTypes.remove(at: index)
            audioButton.setTitle("Audio Off", for: UIControlState())
        } else {
            backTypes.append(.squares)
            audioButton.setTitle("Audio On", for: UIControlState())
        }
        defaults.setValue(backTypes.map { $0.rawValue }, forKey: Constants.backTypesKey)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentBack = defaults.integer(forKey: Constants.nbackLevelKey)
        currentTurns = defaults.integer(forKey: Constants.numberOfTurnsKey)
        
        if let totalCorrect = defaults.object(forKey: "lastGameTotalCorrect") as? Int {
            let outOf = defaults.integer(forKey: "lastGameOutOf")
            let numberOfTurns = defaults.integer(forKey: "lastGameNumberOfTurns")
            let nbackLevel = defaults.integer(forKey: "lastGameNbackLevel")
            let scoreString = "Your score was \(totalCorrect) / \(outOf) with \(numberOfTurns) turns on \(nbackLevel)-back."
            lastPlayLabel.text = scoreString
        } else {
            lastPlayLabel.text = "Welcome to N-Back!"
        }
        
        let back = defaults.integer(forKey: Constants.nbackLevelKey)
        let turns = defaults.integer(forKey: Constants.numberOfTurnsKey)
        
        backButton.setTitle("\(back)-back", for: UIControlState())
        turnsButton.setTitle("\(turns) turns", for: UIControlState())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(currentBack, forKey: Constants.nbackLevelKey)
        defaults.set(currentTurns, forKey: Constants.numberOfTurnsKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        defaults.set(currentBack, forKey: Constants.nbackLevelKey)
        defaults.set(currentTurns, forKey: Constants.numberOfTurnsKey)
        
        let gc = segue.destinationViewController as! GameController
        gc.presentingNGC = self
    }
}
