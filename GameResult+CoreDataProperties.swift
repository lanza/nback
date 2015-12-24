//
//  GameResult+CoreDataProperties.swift
//  n-back project
//
//  Created by Nathan Lanza on 8/6/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension GameResult {

    @NSManaged var date: NSDate?
    @NSManaged var lettersCorrect: NSNumber?
    @NSManaged var lettersIncorrect: NSNumber?
    @NSManaged var lettersMatched: NSNumber?
    @NSManaged var squaresCorrect: NSNumber?
    @NSManaged var squaresIncorrect: NSNumber?
    @NSManaged var squaresMatched: NSNumber?
    @NSManaged var nbackLevel: NSNumber?
    @NSManaged var numberOfTurns: NSNumber?
    @NSManaged var secondsBetweenTurns: NSNumber?

}
