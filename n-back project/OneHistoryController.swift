//
//  OneHistoryController.swift
//  n-back project
//
//  Created by Nathan Lanza on 8/4/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//



import UIKit

class OneHistoryController: UITableViewController {
    var gameResult: GameResult!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: Constants.reuseIdentifier)
        
        let configPlistURL = NSBundle.mainBundle().URLForResource("historyConfig", withExtension: "plist")
        let configPlist = NSDictionary(contentsOfURL: configPlistURL!)!
        let sections = configPlist["sections"]! as! [AnyObject]
        
        let section = sections[indexPath.section] as! [String:AnyObject]
        let rows = section["elements"]! as! [AnyObject]
        let row = rows[indexPath.row] as! [String:String]
        let key = row["key"]!
        
        
        if let theInt = gameResult.valueForKey(key)! as? Int {
            cell.detailTextLabel?.text = String(theInt)
        } else if let theDate = gameResult.valueForKey(key)! as? NSDate {
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(theDate)
        }
        cell.textLabel?.text = row["label"]
        
        return cell
    }
    
    
}
