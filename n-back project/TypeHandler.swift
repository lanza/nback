//
//  TypeHandler.swift
//  n-back project
//
//  Created by Nathan Lanza on 12/23/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit

enum BackType: Int {
    case Squares = 1
    case Numbers = 2
}

let squaresList = ["1","2","3","4","5","6","7","8","9"]
let lettersList = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]



class TypeHandler: NSObject {
    
    var nbackLevel: Int?
    var backType: BackType?
    var numberOfTurns: Int?
    
    convenience init(nbackLevel: Int, backType: BackType, numberOfTurns: Int) {
        self.init()
        self.nbackLevel = nbackLevel
        self.backType = backType
        self.numberOfTurns = numberOfTurns
    }
    
    override init() {
        super.init()
    }
    
    
    func generateSequence() -> [String] {
        
        var sequence = [String]()
        var elementsToChooseFrom = [String]()
        
        switch self.backType! {
        case .Squares:
                elementsToChooseFrom = squaresList
        case .Numbers:
                elementsToChooseFrom = lettersList
        }
        for i in 0...numberOfTurns {
            let index = Int(arc4random_uniform(UInt32(elementsToChooseFrom.count - 1)))
            let randomElement = elementsToChooseFrom[index]
            sequence.append(randomElement)
        }
        return sequence
    }
    
    func compareElements(sequence: [String], userAnswers: [Bool]) -> (Int, Int, Int) {
        
        var correctAnswers = [Bool]()
        var totalMatches = 0
        
        for (var i = nbackLevel!; i < sequence.count; i++) {
            let turns = (latestTurn: sequence[i], nTurnsBack: sequence[i - nbackLevel!])
            let doTheyMatch = (turns.latestTurn == turns.nTurnsBack)
            correctAnswers.append(doTheyMatch)
            if doTheyMatch { totalMatches++ }
        }
        
        var correct = 0
        var incorrect = 0
        var falsePositive = 0
        var falseNegative = 0
        var trueNegative = 0
        var truePositive = 0
        

        for (var i = 0; i < correctAnswers.count; i++) {
            let answers = (correct: correctAnswers[i], user: userAnswers[i])
            
            switch answers {
            case (true,true):
                truePositive++
            case (false,true):
                falsePositive++
            case (true,false):
                falseNegative++
            case (false,false):
                trueNegative++
            }
            
            correct = truePositive
            incorrect = falsePositive
        }
        
        return (correct, incorrect, totalMatches)
    }

}
