//
//  BackTypeResult+CoreDataProperties.swift
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

extension BackTypeResult {

    @NSManaged var backType: NSNumber?
    @NSManaged var correct: NSNumber? // true true
    @NSManaged var incorrect: NSNumber? // false true
    @NSManaged var matches: NSNumber? // true x
    @NSManaged var game: GameResult?

}
