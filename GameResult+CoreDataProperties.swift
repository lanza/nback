//
//  GameResult+CoreDataProperties.swift
//  n-back project
//
//  Created by Nathan Lanza on 12/30/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension GameResult {

    @NSManaged var date: NSDate!  
    @NSManaged var nbackLevel: NSNumber!
    @NSManaged var numberOfTurns: NSNumber!
    @NSManaged var secondsBetweenTurns: NSNumber!
    @NSManaged var backTypes: Set<BackTypeResult>!

}
