//
//  TypeHandler.swift
//  n-back project
//
//  Created by Nathan Lanza on 12/23/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit

enum BackType {
    case Squares
    case Numbers
}

let squaresList = ["1","2","3","4","5","6","7","8","9"]
let lettersList = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]



class TypeHandler: NSObject {
    
    var nbackLevel: Int?
    var backType: BackType?
    
    convenience init(nbackLevel: Int, backType: BackType) {
        self.init()
        self.nbackLevel = nbackLevel
        self.backType = backType
    }
    
    override init() {
        super.init()
    }
    
    
    func generateSequence(count: Int) -> [String] {
        
        var sequence = [String]()
        var elementsToChooseFrom = [String]()
        
        switch self.backType! {
        case .Squares:
                elementsToChooseFrom = squaresList
        case .Numbers:
                elementsToChooseFrom = lettersList
        }
        for (var i = 0; i <= count; i++) {
            let index = Int(arc4random_uniform(UInt32(count - 1)))
            let randomElement = elementsToChooseFrom[index]
            sequence.append(randomElement)
        }
        return sequence
    }
    
    func compareElements(sequence: [String], userAnswers: [Bool]) -> (Int, Int) {
        
        var correctAnswers = [Bool]()
        
        for (var i = nbackLevel!; i < sequence.count; i++) {
            if sequence[i] == sequence[i - nbackLevel!] {
                correctAnswers.append(true)
            } else {
                correctAnswers.append(false)
            }
        }
        
        var correct = 0
        var incorrect = 0

        for (var i = 0; i < correctAnswers.count; i++) {
            if correctAnswers[i] == userAnswers[i] {
                correct++
            } else {
                incorrect++
            }
        }
        
        return (correct, incorrect)
    }

}
