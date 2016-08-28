import UIKit

class OneHistoryController: UITableViewController {
    var gameResult: GameResult!
    
//    override func viewDidLoad() {
//        
//        for backType in gameResult.backTypes {
//            print(backType)
//            print(backType.correct)
//            print(backType.incorrect)
//            print(backType.backType)
//            print(backType.matches)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: Constants.reuseIdentifier)
        
        let configPlistURL = Bundle.main.url(forResource: "historyConfig", withExtension: "plist")
        let configPlist = NSDictionary(contentsOf: configPlistURL!)!
        let sections = configPlist["sections"]! as! [AnyObject]
        
        let section = sections[(indexPath as NSIndexPath).section] as! [String:AnyObject]
        let rows = section["elements"]! as! [AnyObject]
        let row = rows[(indexPath as NSIndexPath).row] as! [String:String]
        let key = row["key"]!
        
        if let theInt = gameResult.value(forKey: key)! as? Int {
            cell.detailTextLabel?.text = String(theInt)
        } else if let theDate = gameResult.value(forKey: key)! as? Date {
            cell.detailTextLabel?.text = dateFormatter.string(from: theDate)
        }
        cell.textLabel?.text = row["label"]
        
        return cell
    }
    
    
}
