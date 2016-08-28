import UIKit
import AVFoundation
import CoreData


class GameController: UIViewController {
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var turnsLabel: UILabel!
    @IBOutlet weak var squareMatchButton: UIButton!
    @IBOutlet weak var numberMatchButton: UIButton!
    @IBOutlet var squares: [UIView]!
    
    @IBAction func squareButton(_ sender: UIButton) {
        brain.squareButtonPushed()
        sender.isEnabled = false
    }
    @IBAction func numberButton(_ sender: UIButton) {
        brain.numberButtonPushed()
        sender.isEnabled = false
    }
    @IBAction func quitButton(_ sender: AnyObject) {
        gameOver()
        brain.timer.invalidate()
    }
    
    var presentingNGC: NewGameController!
    var brain = NBackBrain()
    var duration: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        squareMatchButton.isHidden = true
        numberMatchButton.isHidden = true
        
        backLabel.text = "\(brain.nbackLevel)-back"
        turnsLabel.text = "\(brain.numberOfTurns) turns"
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(newTurn(_:)), name: NSNotification.Name(rawValue: "newTurn"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(gameOver), name: NSNotification.Name(rawValue: "gameOver"), object: nil)
        
        let defaults = UserDefaults.standard
        let backTypes = (defaults.array(forKey: Constants.backTypesKey) as! [Int]).map { BackType(rawValue: $0)! }
        duration = defaults.double(forKey: Constants.blueSquareDurationKey)
        
        for backType in backTypes {
            switch backType {
            case .squares:
                squareMatchButton.isHidden = false
            case .numbers:
                numberMatchButton.isHidden = false
            }
        }
        
        brain.startGame()
    }
    
    func newTurn(_ notification: Notification) {
        let activateButtons = (notification as NSNotification).userInfo!["activateButton"]! as! Bool
        
        if activateButtons {
            squareMatchButton.isEnabled = true
            numberMatchButton.isEnabled = true
        }
        
        let square = (notification as NSNotification).userInfo!["squareNumber"]! as! Int
        squares[square].backgroundColor = UIColor.blue
    }
    
    func gameOver() {
        dismiss(animated: true, completion: { () -> Void in
            if let presenterView = self.presentingNGC.view {
                presenterView.setNeedsDisplay()
            }
        })
    }
    
}
