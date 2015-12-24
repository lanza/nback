import UIKit

struct DefaultsConstants {
    static var nbackLevelKey = "nbackLevel"
    static var numberOfTurnsKey = "numberOfTurns"
    static var secondsBetweenTurnsKey = "secondsBetweenTurns"
    static var blueSquareDurationKey = "blueSquareDuration"
}

class SettingsController: UITableViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var rootArray: [[String: AnyObject]] {
        let configPlistURL = NSBundle.mainBundle().URLForResource("settingsConfig", withExtension: "plist")
        return NSArray(contentsOfURL: configPlistURL!) as! [[String: AnyObject]]
    }
    
    var selectable: Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return (defaults.valueForKey("customMode") as! Bool)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rootArray.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "HI"
        } else {
            return "BYE"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("custom", forIndexPath: indexPath) as! CustomModeCell
            cell.settingsController = self
            
            cell.customModeSwitch.on = self.selectable
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.reuseIdentifier, forIndexPath: indexPath)
            let row = rootArray[indexPath.row]
            
            let label = row["label"] as! String
            cell.textLabel!.text = label
            
            let key = row["key"] as! String
            if let currentValue = defaults.valueForKey(key) {
                cell.detailTextLabel!.text = String(currentValue)
            }
            
            if !selectable {
                cell.backgroundColor = UIColor.lightGrayColor()
                cell.textLabel?.textColor = UIColor.grayColor()
            } else {
                cell.backgroundColor = UIColor.whiteColor()
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return selectable
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let ovc = segue.destinationViewController as! OptionController
        let row = tableView.indexPathForCell(sender as! UITableViewCell)?.row
        ovc.rowInformation = rootArray[row!]
    }
    
    
    
}