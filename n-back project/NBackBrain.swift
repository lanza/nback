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
            
            var defaults: NSUserDefaults!
            
            var nbackLevel: Int!
            var numberOfTurns: Int!
            var secondsBetweenTurns: Double!
            var blueSquareDuration: Double!
            var numbers: [String]!
            //here lies new stuff
            var backTypes: [BackType]!
            //here lies new stuff
            
            override init() {
                super.init()
                self.defaults = NSUserDefaults.standardUserDefaults()
                
                self.numbers = defaults.valueForKey("numbers") as! [String]
                self.nbackLevel = defaults.valueForKey(Constants.nbackLevelKey) as! Int
                self.numberOfTurns = defaults.valueForKey(Constants.numberOfTurnsKey) as! Int
                self.secondsBetweenTurns = defaults.valueForKey(Constants.secondsBetweenTurnsKey) as! Double
                self.blueSquareDuration = defaults.valueForKey(Constants.blueSquareDurationKey) as! Double
                
                //here lies new stuff
                let tempBackTypes = defaults.valueForKey(Constants.backTypesKey) as! [Int]
                self.backTypes = [BackType]()
                for value in tempBackTypes {
                    switch value {
                    case 1:
                        self.backTypes.append(.Squares)
                    case 2:
                        self.backTypes.append(.Numbers)
                    default:
                        assertionFailure()
                    }
                }
                
                //here lies new stuff
            }
            
            //Game Objects
            var notificationCenter: NSNotificationCenter!
            var utterance: AVSpeechUtterance!
            var speechSynthesizer: AVSpeechSynthesizer!
            var timer: NSTimer!
            
            //Gameplay variables
            
            
            
            var currentTurn = 0
            var numberOrder: [String] = [];       var squareOrder: [String] = []
            var numbersMatched: Int?;             var squaresMatched: Int?
            var numbersCorrect: Int?;             var squaresCorrect: Int?
            var numbersIncorrect: Int?;           var squaresIncorrect: Int?
            var numberHandler: TypeHandler?;      var squareHandler: TypeHandler?
            
            func startGame() {
                self.notificationCenter = NSNotificationCenter.defaultCenter()
                
                self.utterance = AVSpeechUtterance()
                self.speechSynthesizer = AVSpeechSynthesizer()
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(self.secondsBetweenTurns, target: self, selector: Selector("timerFire:"), userInfo: nil, repeats: true)
                
                for backType in backTypes {
                    switch backType {
                    case .Squares:
                        self.userAnswersSquare = [Bool]()
                        
                        for _ in nbackLevel...numberOfTurns {
                            self.userAnswersSquare?.append(false)
                        }
                        
                        self.squareHandler = TypeHandler(nbackLevel: self.nbackLevel, backType: .Squares, numberOfTurns: self.numberOfTurns)
                        self.squareOrder = squareHandler!.generateSequence()
                    case .Numbers:
                        self.userAnswersNumber = [Bool]()
                        
                        for _ in nbackLevel...numberOfTurns {
                            self.userAnswersNumber?.append(false)
                        }
                        
                        self.numberHandler = TypeHandler(nbackLevel: self.nbackLevel, backType: .Numbers, numberOfTurns: self.numberOfTurns)
                        self.numberOrder = numberHandler!.generateSequence()
                    }
                }
            }
            
            func timerFire(sender: NSTimer) {
                if currentTurn + 1 <= numberOfTurns {
                    newTurn()
                } else {
                    sender.invalidate()
                    
                    for backType in self.backTypes {
                        switch backType {
                        case .Squares:
                            self.squaresCorrect = 0
                            self.squaresIncorrect = 0
                            self.squaresMatched = 0
                            (self.squaresCorrect!, self.squaresIncorrect!, self.squaresMatched!) = squareHandler!.compareElements(self.squareOrder, userAnswers: self.userAnswersSquare!)
                        case .Numbers:
                            self.numbersCorrect = 0
                            self.numbersIncorrect = 0
                            self.numbersMatched = 0
                            (self.numbersCorrect!, self.numbersIncorrect!, self.numbersMatched!) = numberHandler!.compareElements(self.squareOrder, userAnswers: self.userAnswersNumber!)
                        }
                        
                    }
                    
                    saveGameResults()
                }
            }
            
            func newTurn() {
                var userInfo = [String:AnyObject]()
                let shouldMatchButtonsShow = (currentTurn + 1 > nbackLevel)
                currentTurn++
                
                userInfo.updateValue(shouldMatchButtonsShow, forKey: "activateButton")
                
                for backType in backTypes {
                    switch backType {
                    case .Squares:
                        let square = Int(squareOrder[currentTurn] as String)
                        userInfo.updateValue(square!, forKey: "squareNumber")
                        let duration = self.blueSquareDuration
                        userInfo.updateValue(duration, forKey: "duration")
                        
                    case .Numbers:
                        newNumber()
                    }
                }
                
                let notification = NSNotification(name: "newTurn", object: nil, userInfo: userInfo as [NSObject : AnyObject])
                notificationCenter.postNotification(notification)
            }
            
            func saveGameResults() {
                let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                let result = NSEntityDescription.insertNewObjectForEntityForName(Constants.gameResult, inManagedObjectContext: context) as! GameResult
                
                for backType in backTypes {
                    switch backType {
                    case .Squares:
                        let squareResult = NSEntityDescription.insertNewObjectForEntityForName("BackTypeResult", inManagedObjectContext: context) as! BackTypeResult
                        
                        squareResult.correct = self.squaresCorrect!
                        squareResult.incorrect = self.squaresIncorrect!
                        squareResult.matches = self.squaresMatched!
                        squareResult.backType = 1
                        squareResult.game = result
                        result.backTypes!.insert(squareResult)
                    case .Numbers:
                        let numberResult = NSEntityDescription.insertNewObjectForEntityForName("BackTypeResult", inManagedObjectContext: context) as! BackTypeResult
                        
                        numberResult.correct = self.numbersCorrect!
                        numberResult.incorrect = self.numbersIncorrect!
                        numberResult.matches = self.numbersMatched!
                        numberResult.backType = 2
                        numberResult.game = result
                        result.backTypes!.insert(numberResult)
                    }
                }
                result.setValue(numberOfTurns, forKey: Constants.numberOfTurnsKey)
                result.setValue(secondsBetweenTurns, forKey: Constants.secondsBetweenTurnsKey)
                result.setValue(nbackLevel, forKey: Constants.nbackLevelKey)
                result.setValue(NSDate(), forKey: Constants.dateKey)
                
                //Here should be code to send the gameTypes to the history database.
                
                try! context.save()
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setInteger(result.totalCorrect, forKey: "lastGameTotalCorrect")
                defaults.setInteger(result.outOf, forKey: "lastGameOutOf")
                defaults.setInteger(numberOfTurns, forKey: "lastGameNumberOfTurns")
                defaults.setInteger(nbackLevel, forKey: "lastGameNbackLevel")
                
                let notification = NSNotification(name: "gameOver", object: nil, userInfo: nil)
                notificationCenter.postNotification(notification)
            }
            
            func newNumber() {
                
                let toBeSpoken = numberOrder[currentTurn]
                let utterance = AVSpeechUtterance(string: toBeSpoken)
                speechSynthesizer.speakUtterance(utterance)
                
            }
            
            var userAnswersSquare: [Bool]?
            var userAnswersNumber: [Bool]?
            
            func squareButtonPushed() {
                self.userAnswersSquare![currentTurn - nbackLevel] = true
            }
            func numberButtonPushed() {
                self.userAnswersNumber![currentTurn - nbackLevel] = true
            }
        }
