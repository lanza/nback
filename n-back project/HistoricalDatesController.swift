//
//  HistoricalDatesController.swift
//  n-back project
//
//  Created by Nathan Lanza on 8/7/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit
import CoreData

class HistoricalDatesController: UITableViewController, NSFetchedResultsControllerDelegate {

    var context: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    var _fetchedResultsController: NSFetchedResultsController!
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("GameResult", inManagedObjectContext: self.context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let afrc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        afrc.delegate = self
        _fetchedResultsController = afrc
        
        do {
            try _fetchedResultsController.performFetch()
        } catch {
            print("fetch failed")
            abort()
        }
        
        return _fetchedResultsController
    }
    
    var datesDictionary: [String: Int] = Dictionary()
    var arrayOfDates: [(String, Int)] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! fetchedResultsController.performFetch()
        
        for object in fetchedResultsController.fetchedObjects! as! [GameResult] {
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            let date = dateFormatter.stringFromDate(object.date!)
            
            if let value = datesDictionary[date] {
                datesDictionary[date] = value + 1
            } else {
                datesDictionary[date] = 1
            }
        }
        
        
        for (key, value) in datesDictionary {
            arrayOfDates.append((key, value))
        }
        
        arrayOfDates.sortInPlace { (one, two) -> Bool in
            let firstDate = dateFormatter.dateFromString(one.0)
            let secondDate = dateFormatter.dateFromString(two.0)
            return firstDate?.compare(secondDate!) == NSComparisonResult.OrderedAscending
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        try! self.fetchedResultsController.performFetch()
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = arrayOfDates[indexPath.row].0
        cell.detailTextLabel?.text = "\(arrayOfDates[indexPath.row].1) games played."
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let date = dateFormatter.dateFromString((sender as! UITableViewCell).textLabel!.text!)
        let hvc = segue.destinationViewController as! HistoryController
        
        hvc.date = date
        
    }
}
