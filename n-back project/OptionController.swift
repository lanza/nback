import UIKit

class OptionController: UITableViewController {
    
    var rowInformation: [String: AnyObject]!
    var values: [Double] {
        return self.rowInformation["values"] as! [Double]
    }
    var currentValue: Double {
        get {
            let defaults = UserDefaults.standard()
            return defaults.value(forKey: rowInformation["key"] as! String)! as! Double
        }
        set {
            let defaults = UserDefaults.standard()
            
            let key = rowInformation["key"] as! String
            
            if (rowInformation["type"] as! String) == "int" {
                defaults.set(Int(newValue), forKey: key)
            } else if (rowInformation["type"] as! String) == "double" {
                defaults.set(Double(newValue), forKey: key)
            }
        }
    }

    
    override func viewDidLoad() {
        navigationItem.title = rowInformation["label"] as! String?
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier)
        
        let type = rowInformation["type"] as! String
        let value = values[(indexPath as NSIndexPath).row]
        
        if type == "double" {
            cell?.textLabel?.text = String(value)
        } else if type == "int" {
            cell?.textLabel?.text = String(Int(value))
        }
        
        cell?.textLabel?.text = String(values[(indexPath as NSIndexPath).row])
        
        if values[(indexPath as NSIndexPath).row] != currentValue {
            cell?.accessoryType = UITableViewCellAccessoryType.none
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        return cell!
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        
        currentValue = Double((cell?.textLabel?.text)!)!
        tableView.reloadData()

    }

}
