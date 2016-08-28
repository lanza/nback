import UIKit
import AVFoundation
import CoreData


class NBackBrain {
    var defaults: UserDefaults!
    
    var nbackLevel: Int
    var numberOfTurns: Int
    var secondsBetweenTurns: Double
    var blueSquareDuration: Double
    var numbers: [String]
    //here lies new stuff
    var backTypes: [BackType]
    //here lies new stuff
    
    init() {
        defaults = UserDefaults.standard
        
        numbers = defaults.array(forKey: Constants.numbers) as! [String]
        nbackLevel = defaults.integer(forKey: Constants.nbackLevelKey)
        numberOfTurns = defaults.integer(forKey: Constants.numberOfTurnsKey)
        secondsBetweenTurns = defaults.double(forKey: Constants.secondsBetweenTurnsKey)
        blueSquareDuration = defaults.double(forKey: Constants.blueSquareDurationKey)
        
        //here lies new stuff
        backTypes = (defaults.array(forKey: Constants.backTypesKey) as! [Int]).map { BackType(rawValue: $0)! }
    }
    
    //Game Objects
    var notificationCenter: NotificationCenter!
    var utterance: AVSpeechUtterance!
    var speechSynthesizer: AVSpeechSynthesizer!
    var timer: Timer!
    
    //Gameplay variables
    var currentTurn = 0
    var numberOrder = [String]();       var squareOrder = [String]()
    var numbersMatched: Int!;           var squaresMatched: Int!
    var numbersCorrect: Int!;           var squaresCorrect: Int!
    var numbersIncorrect: Int!;         var squaresIncorrect: Int!
    var numberHandler: TypeHandler!;    var squareHandler: TypeHandler!
    
    func startGame() {
        notificationCenter = NotificationCenter.default
        
        utterance = AVSpeechUtterance()
        speechSynthesizer = AVSpeechSynthesizer()
        
        timer = Timer.scheduledTimer(timeInterval: secondsBetweenTurns, target: self, selector: #selector(NBackBrain.timerFire(_:)), userInfo: nil, repeats: true)
        
        for backType in backTypes {
            switch backType {
            case .squares:
                userAnswersSquare = [Bool]()
                
                for _ in nbackLevel..<numberOfTurns {
                    userAnswersSquare.append(false)
                }
                
                squareHandler = TypeHandler(nbackLevel: nbackLevel, backType: .squares, numberOfTurns: numberOfTurns)
                squareOrder = squareHandler.generateSequence()
            case .numbers:
                userAnswersNumber = [Bool]()
                
                for _ in nbackLevel..<numberOfTurns {
                    userAnswersNumber.append(false)
                }
                
                numberHandler = TypeHandler(nbackLevel: nbackLevel, backType: .numbers, numberOfTurns: numberOfTurns)
                numberOrder = numberHandler.generateSequence()
            }
        }
    }
    
    @objc func timerFire(_ sender: Timer) {
        if currentTurn < numberOfTurns {
            newTurn()
        } else {
            sender.invalidate()
            
            for backType in backTypes {
                switch backType {
                case .squares:
                    squaresCorrect = 0
                    squaresIncorrect = 0
                    squaresMatched = 0
                    (squaresCorrect!, squaresIncorrect!, squaresMatched!) = squareHandler.compareElements(squareOrder, userAnswers: userAnswersSquare)
                case .numbers:
                    numbersCorrect = 0
                    numbersIncorrect = 0
                    numbersMatched = 0
                    (numbersCorrect!, numbersIncorrect!, numbersMatched!) = numberHandler.compareElements(numberOrder, userAnswers: userAnswersNumber)
                }
            }
            saveGameResults()
        }
    }
    
    func newTurn() {
        currentTurn += 1
        var userInfo = [String:Any]()
        let shouldMatchButtonsShow = currentTurn > nbackLevel
        userInfo[ "activateButton"] = shouldMatchButtonsShow
        
        for backType in backTypes {
            switch backType {
            case .squares:
                let square = Int(squareOrder[currentTurn-1])!
                userInfo["squareNumber"] = square
            case .numbers:
                newNumber()
            }
        }
        let notification = Notification(name: Notification.Name("newTurn"), object: nil, userInfo: userInfo)
        notificationCenter.post(notification)
    }
    
    func saveGameResults() {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let result = NSEntityDescription.insertNewObject(forEntityName: Constants.gameResult, into: context) as! GameResult
        
        for backType in backTypes {
            switch backType {
            case .squares:
                let squareResult = NSEntityDescription.insertNewObject(forEntityName: "BackTypeResult", into: context) as! BackTypeResult
                
                squareResult.correct = squaresCorrect as NSNumber
                squareResult.incorrect = squaresIncorrect as NSNumber
                squareResult.matches = squaresMatched as NSNumber
                squareResult.backType = 1
                squareResult.game = result
                result.backTypes!.insert(squareResult)
            case .numbers:
                let numberResult = NSEntityDescription.insertNewObject(forEntityName: "BackTypeResult", into: context) as! BackTypeResult
                
                numberResult.correct = numbersCorrect as NSNumber
                numberResult.incorrect = numbersIncorrect as NSNumber
                numberResult.matches = numbersMatched as NSNumber
                numberResult.backType = 2
                numberResult.game = result
                result.backTypes!.insert(numberResult)
            }
        }
        result.setValue(numberOfTurns, forKey: Constants.numberOfTurnsKey)
        result.setValue(secondsBetweenTurns, forKey: Constants.secondsBetweenTurnsKey)
        result.setValue(nbackLevel, forKey: Constants.nbackLevelKey)
        result.setValue(Date(), forKey: Constants.dateKey)
        
        //Here should be code to send the gameTypes to the history database.
        
        try! context.save()
        
        let defaults = UserDefaults.standard
        defaults.set(result.totalCorrect, forKey: "lastGameTotalCorrect")
        defaults.set(result.outOf, forKey: "lastGameOutOf")
        defaults.set(numberOfTurns, forKey: "lastGameNumberOfTurns")
        defaults.set(nbackLevel, forKey: "lastGameNbackLevel")
        
        let notification = Notification(name: Notification.Name("gameOver"), object: nil, userInfo: nil)
        notificationCenter.post(notification)
    }
    
    func newNumber() {
        
        let toBeSpoken = numberOrder[currentTurn-1]
        let utterance = AVSpeechUtterance(string: toBeSpoken)
        speechSynthesizer.speak(utterance)
        
    }
    
    var userAnswersSquare: [Bool]!
    var userAnswersNumber: [Bool]!
    
    func squareButtonPushed() {
        userAnswersSquare![currentTurn - nbackLevel - 1] = true
    }
    func numberButtonPushed() {
        userAnswersNumber![currentTurn - nbackLevel - 1] = true
    }
}
