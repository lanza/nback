import UIKit

class CustomModeCell: UITableViewCell {
    
    @IBOutlet weak var customModeSwitch: UISwitch!
    
    weak var settingsController: SettingsController!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            let popover = UIAlertController(title: "Switch to custum mode?", message: "Enabling custom mode allows you to pick the n-back level, the number of turns, the duration between each turn and the duration which a square lights up blue. This, however, disables the built in progression system.", preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                ()
            })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
                let customMode = self.settingsController.defaults.value(forKey: "customMode") as! Bool
                self.settingsController.defaults.set(!customMode, forKey: "customMode")
                
                self.settingsController.tableView.reloadData()
            })
            popover.addAction(okay)
            popover.addAction(cancel)
            
            settingsController.present(popover, animated: true, completion: { () -> Void in
                ()
            })
        }
        let customMode = self.settingsController.defaults.value(forKey: "customMode") as! Bool
        self.settingsController.defaults.set(!customMode, forKey: "customMode")
        
        self.settingsController.tableView.reloadData()
    }
}
