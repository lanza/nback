import UIKit
import AVFoundation
import CoreData


class GameController: UIViewController {
    
    var presentingNGC: NewGameController!
    var brain = NBackBrain()
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var turnsLabel: UILabel!
    
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
    @IBOutlet weak var letterMatchButton: UIButton!
    
    @IBAction func squareButton(sender: UIButton) {
        brain.squareButtonPushed()
        sender.enabled = false
    }
    @IBAction func letterButton(sender: UIButton) {
        brain.letterButtonPushed()
        sender.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backLabel.text = "\(brain.nbackLevel)-back"
        self.turnsLabel.text = "\(brain.numberOfTurns) turns"
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "newTurn:", name: "gewTurn", object: nil)
        notificationCenter.addObserver(self, selector: "gameOver", name: "gameOver", object: nil)

        
        brain.startGame()
    }
    
    func newTurn(notification: NSNotification) {
        let activateButtons = notification.userInfo!["activateButtons"]! as! Bool
        
        if activateButtons {
            squareMatchButton.enabled = true
            letterMatchButton.enabled = true
        }
        
        let square = notification.userInfo!["squareNumber"]! as! Int
        squares[square].backgroundColor = UIColor.blueColor()
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
