//
//  BTRPolicy.swift
//  n-back project
//
//  Created by Nathan Lanza on 12/29/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit
import CoreData


class BTRPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinationManagedObjectContext = manager.destinationContext
        let destinationEntityName = mapping.destinationEntityName
        
        let dInstance = NSEntityDescription.insertNewObjectForEntityForName(destinationEntityName!, inManagedObjectContext: destinationManagedObjectContext)
        
        func setForKey(key: String) {
            dInstance.setValue(sInstance.valueForKey(key), forKey: key)
        }
        
        setForKey(Constants.dateKey)
        setForKey(Constants.nbackLevelKey)
        setForKey(Constants.numberOfTurnsKey)
        setForKey(Constants.secondsBetweenTurnsKey)
        
        let squareBackType = NSEntityDescription.insertNewObjectForEntityForName("BackTypeResult", inManagedObjectContext: destinationManagedObjectContext)
        let numberBackType = NSEntityDescription.insertNewObjectForEntityForName("BackTypeResult", inManagedObjectContext: destinationManagedObjectContext)
        
        squareBackType.setValue(sInstance.valueForKey(Constants.squaresCorrectKey), forKey: "correct")
        squareBackType.setValue(sInstance.valueForKey(Constants.squaresIncorrectKey), forKey: "incorrect")
        squareBackType.setValue(sInstance.valueForKey(Constants.squaresMatchedKey), forKey: "matches")
        squareBackType.setValue(1, forKey: "backType")
        
        numberBackType.setValue(sInstance.valueForKey(Constants.lettersCorrectKey), forKey: "correct")
        numberBackType.setValue(sInstance.valueForKey(Constants.lettersIncorrectKey), forKey: "incorrect")
        numberBackType.setValue(sInstance.valueForKey(Constants.lettersMatchedKey), forKey: "matches")
        numberBackType.setValue(2, forKey: "backType")
        
        squareBackType.setValue(dInstance, forKey: "game")
        numberBackType.setValue(dInstance, forKey: "game")
        
        enum Error: ErrorType {
            case One
        }
        
        manager.associateSourceInstance(sInstance, withDestinationInstance: dInstance, forEntityMapping: mapping)
    }
}
