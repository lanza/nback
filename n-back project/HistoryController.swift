import UIKit
import CoreData

var dateFormatter = NSDateFormatter()

class HistoryController: UITableViewController, NSFetchedResultsControllerDelegate {

    var date: NSDate!
    
    var context: NSManagedObjectContext {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }

    // MARK: - Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    // MARK: - FetchedResultsController setup
    
    var frc: NSFetchedResultsController!
    
    
    var fetchedResultsController: NSFetchedResultsController {
        if frc != nil {
            return frc
        }
        
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("GameResult", inManagedObjectContext: self.context)
        fetchRequest.entity = entity
        
        let comps = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        comps.day = calendar.component(.Day, fromDate: self.date)
        comps.month = calendar.component(.Month, fromDate: self.date)
        comps.year = calendar.component(.Year, fromDate: self.date)
        
        let beginningDate = calendar.dateFromComponents(comps)
        let endingDate = beginningDate!.dateByAddingTimeInterval(60*60*24)
        
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", argumentArray: [beginningDate!,endingDate])
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let afrc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        afrc.delegate = self
        frc = afrc
        
        do {
            try frc!.performFetch()
        } catch {
            print("fetch failed")
            abort()
        }
        
        return frc
    }

    // MARK: - FetchedResultsController delegate
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SingleGameHistoryCell
        
        let result  = fetchedResultsController.objectAtIndexPath(indexPath) as! GameResult
        
        cell.dateLabel.text = result.dateString
        cell.scoreLabel.text = result.scoreString
        cell.backAndTurnsLabel.text = result.backAndTurnsString
        
       
        

        
    
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedCell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(selectedCell)!
        let ohc = segue.destinationViewController as! OneHistoryController
        ohc.gameResult = fetchedResultsController.objectAtIndexPath(indexPath) as! GameResult
    }

}
