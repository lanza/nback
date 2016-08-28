import UIKit
import CoreData


class BTRPolicy: NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        let destinationManagedObjectContext = manager.destinationContext
        let destinationEntityName = mapping.destinationEntityName
        
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: destinationEntityName!, into: destinationManagedObjectContext)
        
        func setForKey(_ key: String) {
            dInstance.setValue(sInstance.value(forKey: key), forKey: key)
        }
        
        setForKey(Constants.dateKey)
        setForKey(Constants.nbackLevelKey)
        setForKey(Constants.numberOfTurnsKey)
        setForKey(Constants.secondsBetweenTurnsKey)
        
        let squareBackType = NSEntityDescription.insertNewObject(forEntityName: "BackTypeResult", into: destinationManagedObjectContext)
        let numberBackType = NSEntityDescription.insertNewObject(forEntityName: "BackTypeResult", into: destinationManagedObjectContext)
        
        squareBackType.setValue(sInstance.value(forKey: Constants.squaresCorrectKey), forKey: "correct")
        squareBackType.setValue(sInstance.value(forKey: Constants.squaresIncorrectKey), forKey: "incorrect")
        squareBackType.setValue(sInstance.value(forKey: Constants.squaresMatchedKey), forKey: "matches")
        squareBackType.setValue(1, forKey: "backType")
        
        numberBackType.setValue(sInstance.value(forKey: Constants.lettersCorrectKey), forKey: "correct")
        numberBackType.setValue(sInstance.value(forKey: Constants.lettersIncorrectKey), forKey: "incorrect")
        numberBackType.setValue(sInstance.value(forKey: Constants.lettersMatchedKey), forKey: "matches")
        numberBackType.setValue(2, forKey: "backType")
        
        squareBackType.setValue(dInstance, forKey: "game")
        numberBackType.setValue(dInstance, forKey: "game")
        
        enum Errored: Error {
            case one
        }
        
        manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
    }
}
