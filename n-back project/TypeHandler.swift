import UIKit

enum BackType: Int {
    case squares = 1
    case numbers = 2
}

let squaresList = ["1","2","3","4","5","6","7","8","9"]
let lettersList = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

protocol BackTypeProtocol {
    associatedtype Element
    var elements: [Element] { get }
}

struct Squares: BackTypeProtocol {
    let elements = [1,2,3,4,5,6,7,8,9]
}

struct Letters: BackTypeProtocol {
    let elements = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
}

//TODO: Implement protocol?

class TypeHandler {
    
    var nbackLevel: Int
    var backType: BackType
    var numberOfTurns: Int
    
    init(nbackLevel: Int, backType: BackType, numberOfTurns: Int) {
        self.nbackLevel = nbackLevel
        self.backType = backType
        self.numberOfTurns = numberOfTurns
    }
    
    func generateSequence() -> [String] {
        
        var sequence = [String]()
        var elementsToChooseFrom = [String]()
        
        switch backType {
        case .squares:
                elementsToChooseFrom = squaresList
        case .numbers:
                elementsToChooseFrom = lettersList
        }
        for _ in 0..<numberOfTurns {
            let index = Int(arc4random_uniform(UInt32(elementsToChooseFrom.count - 1)))
            let randomElement = elementsToChooseFrom[index]
            sequence.append(randomElement)
        }
        return sequence
    }
    
    func compareElements(_ sequence: [String], userAnswers: [Bool]) -> (Int, Int, Int) {
        print(sequence)
        print(userAnswers)

        var correctAnswers = [Bool]()
        var totalMatches = 0
        
        for i in nbackLevel ..< sequence.count {
            let turns = (latestTurn: sequence[i], nTurnsBack: sequence[i - nbackLevel])
            let doTheyMatch = (turns.latestTurn == turns.nTurnsBack)
            correctAnswers.append(doTheyMatch)
            if doTheyMatch { totalMatches += 1 }
        }
        
        var correct = 0
        var incorrect = 0
        var falsePositive = 0
        var falseNegative = 0
        var trueNegative = 0
        var truePositive = 0
        

        for i in 0..<correctAnswers.count {
            let answers = (correct: correctAnswers[i], user: userAnswers[i])
            
            switch answers {
            case (true,true):
                truePositive += 1
            case (false,true):
                falsePositive += 1
            case (true,false):
                falseNegative += 1
            case (false,false):
                trueNegative += 1
            }
        }
        
        correct = truePositive
        incorrect = falsePositive
        
        return (correct, incorrect, totalMatches)
    }

}
