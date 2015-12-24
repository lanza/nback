//
//  NBackBrain.swift
//  n-back project
//
//  Created by Nathan Lanza on 12/22/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData


class NBackBrain: NSObject {

    
    var nbackLevel: Int!
    var numberOfTurns: Int!
    var secondsBetweenTurns: Double!
    var blueSquareDuration: Double!
    var numbers: [String]!
    
    override init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        self.numbers = defaults.valueForKey("numbers") as! [String]
        self.nbackLevel = defaults.valueForKey(DefaultsConstants.nbackLevelKey) as! Int
        self.numberOfTurns = defaults.valueForKey(DefaultsConstants.numberOfTurnsKey) as! Int
        self.secondsBetweenTurns = defaults.valueForKey(DefaultsConstants.secondsBetweenTurnsKey) as! Double
        self.blueSquareDuration = defaults.valueForKey(DefaultsConstants.blueSquareDurationKey) as! Double
    }
    
    //Game Objects
    var notificationCenter: NSNotificationCenter!
    var utterance: AVSpeechUtterance!
    var speechSynthesizer: AVSpeechSynthesizer!
    var timer: NSTimer!
    
    //Gameplay variables
    var currentTurn = 1
    var letterOrder: [String] = [];     var squareOrder: [Int] = []
    var letterDidMatch: Bool!;          var squareDidMatch: Bool!
    var lettersMatched = 0;             var squaresMatched = 0
    var lettersCorrect = 0;             var squaresCorrect = 0
    var lettersIncorrect = 0;           var squaresIncorrect = 0
    
    func startGame() {
        
        self.notificationCenter = NSNotificationCenter.defaultCenter()
        
        self.utterance = AVSpeechUtterance()
        self.speechSynthesizer = AVSpeechSynthesizer()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.secondsBetweenTurns, target: self, selector: Selector("timerFire:"), userInfo: nil, repeats: true)
    }
    

    
    func timerFire(sender: NSTimer) {
        if currentTurn > numberOfTurns {
            sender.invalidate()
            
            let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let result = NSEntityDescription.insertNewObjectForEntityForName(Constants.gameResult, inManagedObjectContext: context) as! GameResult
            result.setValue(lettersCorrect, forKey: Constants.lettersCorrectKey)
            result.setValue(squaresCorrect, forKey: Constants.squaresCorrectKey)
            result.setValue(lettersIncorrect, forKey: Constants.lettersIncorrectKey)
            result.setValue(squaresIncorrect, forKey: Constants.squaresIncorrectKey)
            result.setValue(lettersMatched, forKey: Constants.lettersMatchedKey)
            result.setValue(squaresMatched, forKey: Constants.squaresMatchedKey)
            result.setValue(numberOfTurns, forKey: Constants.numberOfTurnsKey)
            result.setValue(secondsBetweenTurns, forKey: Constants.secondsBetweenTurnsKey)
            result.setValue(nbackLevel, forKey: Constants.nbackLevelKey)
            result.setValue(NSDate(), forKey: Constants.dateKey)
            
            try! context.save()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(result.totalCorrect, forKey: "lastGameTotalCorrect")
            defaults.setInteger(result.outOf, forKey: "lastGameOutOf")
            defaults.setInteger(numberOfTurns, forKey: "lastGameNumberOfTurns")
            defaults.setInteger(nbackLevel, forKey: "lastGameNbackLevel")
            
            let notification = NSNotification(name: "gameOver", object: nil, userInfo: nil)
            notificationCenter.postNotification(notification)
            
        } else {
            let activateButton = (currentTurn>nbackLevel)
            currentTurn++
            newLetter()
            let square = newSquare()
            let duration = self.blueSquareDuration
            let userInfo = ["activateButton":activateButton, "squareNumber": square, "duration": duration]
            let notification = NSNotification(name: "newTurn", object: nil, userInfo: userInfo as [NSObject : AnyObject])
            notificationCenter.postNotification(notification)
        }
    }
    
    func newLetter() {
        let index = Int(arc4random_uniform(UInt32(numbers.count - 1)))
        let utterance = AVSpeechUtterance(string: numbers[index])
        speechSynthesizer.speakUtterance(utterance)
        letterOrder.append(numbers[index])
        
        if letterOrder.count > nbackLevel {
            let lastLetter = letterOrder.last!
            let backLetter = letterOrder[letterOrder.count - 1 - nbackLevel]
            if backLetter == lastLetter {
                lettersMatched++
                letterDidMatch = true
            } else {
                letterDidMatch = false
            }
        }
    }
    
    func newSquare() -> Int {
        let square = Int(arc4random_uniform(UInt32(8)))
        
        squareOrder.append(square)
        
        if squareOrder.count > nbackLevel {
            let lastSquare = squareOrder.last!
            let backSquare = squareOrder[squareOrder.count - 1 - nbackLevel]
            if backSquare == lastSquare {
                squaresMatched++
                squareDidMatch = true
            } else {
                squareDidMatch = false
            }
        }
        return square
    }
    

    
    func squareButtonPushed() {
        if squareDidMatch == true {
            squaresCorrect++
        } else {
            squaresIncorrect++
        }
    }
    func letterButtonPushed() {
        if letterDidMatch == true {
            lettersCorrect++
        } else {
            lettersIncorrect++
        }
    }    
}
