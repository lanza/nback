//
//  OptionController.swift
//  n-back project
//
//  Created by Nathan Lanza on 8/7/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit

class OptionController: UITableViewController {
    
    var rowInformation: [String: AnyObject]!
    var values: [Double] {
        return self.rowInformation["values"] as! [Double]
    }
    var currentValue: Double {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.valueForKey(rowInformation["key"] as! String)! as! Double
        }
        set {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let key = rowInformation["key"] as! String
            
            if (rowInformation["type"] as! String) == "int" {
                defaults.setInteger(Int(newValue), forKey: key)
            } else if (rowInformation["type"] as! String) == "double" {
                defaults.setDouble(Double(newValue), forKey: key)
            }
        }
    }

    
    override func viewDidLoad() {
        navigationItem.title = rowInformation["label"] as! String?
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.reuseIdentifier)
        
        let type = rowInformation["type"] as! String
        let value = values[indexPath.row]
        
        if type == "double" {
            cell?.textLabel?.text = String(value)
        } else if type == "int" {
            cell?.textLabel?.text = String(Int(value))
        }
        
        cell?.textLabel?.text = String(values[indexPath.row])
        
        if values[indexPath.row] != currentValue {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell!
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        
        currentValue = Double((cell?.textLabel?.text)!)!
        tableView.reloadData()

    }

}
