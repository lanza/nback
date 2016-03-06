import UIKit
import AVFoundation
import CoreData


class GameController: UIViewController {
    
    var presentingNGC: NewGameController!
    var brain = NBackBrain()
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var turnsLabel: UILabel!
    
    @IBAction func quitButton(sender: AnyObject) {
        gameOver()
        brain.timer.invalidate()
    }
    @IBOutlet var squares: [UIView]! {
        didSet {
            for square in squares {
                square.layer.borderColor = UIColor.blackColor().CGColor
                square.layer
                    .borderWidth = 1
            }
        }
    }
    
    @IBOutlet weak var squareMatchButton: UIButton!
    @IBOutlet weak var numberMatchButton: UIButton!
    
    @IBAction func squareButton(sender: UIButton) {
        brain.squareButtonPushed()
        sender.enabled = false
    }
    @IBAction func numberButton(sender: UIButton) {
        brain.numberButtonPushed()
        sender.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.squareMatchButton.hidden = true
        self.numberMatchButton.hidden = true
        
        self.backLabel.text = "\(brain.nbackLevel)-back"
        self.turnsLabel.text = "\(brain.numberOfTurns) turns"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: #selector(newTurn(_:)), name: "newTurn", object: nil)
        notificationCenter.addObserver(self, selector: #selector(gameOver), name: "gameOver", object: nil)

        let defaults = NSUserDefaults.standardUserDefaults()
        let backTypes = defaults.valueForKey(Constants.backTypesKey) as! [Int]
        
        for backType in backTypes {
            switch backType {
            case 1:
                self.squareMatchButton.hidden = false
            case 2:
                self.numberMatchButton.hidden = false
            default:
                assertionFailure()
            }
        }
        
        brain.startGame()
    }
    
    func newTurn(notification: NSNotification) {
        let activateButtons = notification.userInfo!["activateButton"]! as! Bool
        
        if activateButtons {
            squareMatchButton.enabled = true
            numberMatchButton.enabled = true
            print(activateButtons)
        }
        
       
        let square = notification.userInfo!["squareNumber"]! as! Int
        squares[square].backgroundColor = UIColor.blueColor()
         print(square)
        let duration = notification.userInfo!["duration"] as! Double
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.squares[square].backgroundColor = UIColor.whiteColor()
        }
    }
    
    func gameOver() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let presenterView = self.presentingNGC.view {
                presenterView.setNeedsDisplay()
            }
        })
    }
    
}
