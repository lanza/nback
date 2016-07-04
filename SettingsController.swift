import UIKit

class SettingsController: UITableViewController {
    
    var defaults = UserDefaults.standard()
    
    var rootArray: [[String: AnyObject]] {
        let configPlistURL = Bundle.main().urlForResource("settingsConfig", withExtension: "plist")
        return NSArray(contentsOf: configPlistURL!) as! [[String: AnyObject]]
    }
    
    var selectable: Bool {
        let defaults = UserDefaults.standard()
        return (defaults.value(forKey: "customMode") as! Bool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rootArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "HI"
        } else {
            return "BYE"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomModeCell
            cell.settingsController = self
            
            cell.customModeSwitch.isOn = self.selectable
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
            let row = rootArray[(indexPath as NSIndexPath).row]
            
            let label = row["label"] as! String
            cell.textLabel!.text = label
            
            let key = row["key"] as! String
            if let currentValue = defaults.value(forKey: key) {
                cell.detailTextLabel!.text = String(currentValue)
            }
            
            if !selectable {
                cell.backgroundColor = UIColor.lightGray()
                cell.textLabel?.textColor = UIColor.gray()
            } else {
                cell.backgroundColor = UIColor.white()
                cell.textLabel?.textColor = UIColor.black()
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return selectable
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let ovc = segue.destinationViewController as! OptionController
        let row = (tableView.indexPath(for: sender as! UITableViewCell) as NSIndexPath?)?.row
        ovc.rowInformation = rootArray[row!]
    }
    
    
    
}
