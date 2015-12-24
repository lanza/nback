import UIKit

class CustomModeCell: UITableViewCell {
    
    @IBOutlet weak var customModeSwitch: UISwitch!
    
    weak var settingsController: SettingsController!
    
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on == true {
            let popover = UIAlertController(title: "Switch to custum mode?", message: "Enabling custom mode allows you to pick the n-back level, the number of turns, the duration between each turn and the duration which a square lights up blue. This, however, disables the built in progression system.", preferredStyle: UIAlertControllerStyle.Alert)
            let okay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                ()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                let customMode = self.settingsController.defaults.valueForKey("customMode") as! Bool
                self.settingsController.defaults.setBool(!customMode, forKey: "customMode")
                
                self.settingsController.tableView.reloadData()
            })
            popover.addAction(okay)
            popover.addAction(cancel)
            
            settingsController.presentViewController(popover, animated: true, completion: { () -> Void in
                ()
            })
        }
        let customMode = self.settingsController.defaults.valueForKey("customMode") as! Bool
        self.settingsController.defaults.setBool(!customMode, forKey: "customMode")
        
        self.settingsController.tableView.reloadData()
    }
}
