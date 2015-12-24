//
//  NewGameController.swift
//  n-back project
//
//  Created by Nathan Lanza on 8/6/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit


class NewGameController: UIViewController {
    
    var brain: NBackBrain!
    
    @IBOutlet weak var lastPlayLabel: UILabel!
    var defaults: NSUserDefaults!
    
    @IBOutlet weak var turnsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func turnsButtonPushed(sender: AnyObject) {
        var currentTurns = self.defaults.valueForKey(DefaultsConstants.numberOfTurnsKey) as! Int
        switch (currentTurns) {
        case 26:
            currentTurns = 10
        default:
            currentTurns++
        }
        self.defaults.setValue(currentTurns, forKey: DefaultsConstants.numberOfTurnsKey)
        
        self.turnsButton.setTitle("\(currentTurns) turns", forState: .Normal)
        self.turnsButton.setTitle("\(currentTurns) turns", forState: .Selected)
        
    }
    @IBAction func backButtonPushed(sender: AnyObject) {
        var currentBack = self.defaults.valueForKey(DefaultsConstants.nbackLevelKey) as! Int
        switch (currentBack) {
        case 6:
            currentBack = 1
        default:
            currentBack++
        }
        self.defaults.setValue(currentBack, forKey: DefaultsConstants.nbackLevelKey)
        
        self.backButton.setTitle("\(currentBack)-back", forState: .Normal)
        self.backButton.setTitle("\(currentBack)-back", forState: .Selected)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.defaults = NSUserDefaults.standardUserDefaults()
        
        if let totalCorrect = self.defaults.objectForKey("lastGameTotalCorrect") as? Int {
            let outOf = self.defaults.objectForKey("lastGameOutOf") as! Int
            let numberOfTurns = self.defaults.objectForKey("lastGameNumberOfTurns") as! Int
            let nbackLevel = self.defaults.objectForKey("lastGameNbackLevel") as! Int
            let scoreString = "Your score was \(totalCorrect) / \(outOf) with \(numberOfTurns) turns on \(nbackLevel)-back."
            self.lastPlayLabel.text = scoreString
        } else {
            self.lastPlayLabel.text = "Welcome to N-Back!"
        }
        
        let back = self.defaults.valueForKey(DefaultsConstants.nbackLevelKey) as! Int
        let turns = self.defaults.valueForKey(DefaultsConstants.numberOfTurnsKey) as! Int
        
        self.backButton.setTitle("\(back)-back", forState: .Normal)
        self.backButton.setTitle("\(back)-back", forState: .Selected)
        
        self.turnsButton.setTitle("\(turns) turns", forState: .Normal)
        self.turnsButton.setTitle("\(turns) turns", forState: .Selected)
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gvc = segue.destinationViewController as! GameController
        gvc.presentingNGC = self
    }
    
    
}
