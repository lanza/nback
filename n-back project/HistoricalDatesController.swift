import UIKit
import CoreData

class HistoricalDatesController: UITableViewController, NSFetchedResultsControllerDelegate {

    var context: NSManagedObjectContext {
        return (UIApplication.shared().delegate as! AppDelegate).managedObjectContext
    }
    var _fetchedResultsController: NSFetchedResultsController<GameResult>!
    var fetchedResultsController: NSFetchedResultsController<GameResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }
        
        let fetchRequest = NSFetchRequest<GameResult>()
        let entity = NSEntityDescription.entity(forEntityName: "GameResult", in: self.context)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [SortDescriptor(key: "date", ascending: true)]
        
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
        
        for object in fetchedResultsController.fetchedObjects! {
            dateFormatter.timeStyle = DateFormatter.Style.noStyle
            dateFormatter.dateStyle = DateFormatter.Style.mediumStyle
            let date = dateFormatter.string(from: object.date!)
            
            if let value = datesDictionary[date] {
                datesDictionary[date] = value + 1
            } else {
                datesDictionary[date] = 1
            }
        }
        
        
        for (key, value) in datesDictionary {
            arrayOfDates.append((key, value))
        }
        
        arrayOfDates.sort { (one, two) -> Bool in
            let firstDate = dateFormatter.date(from: one.0)
            let secondDate = dateFormatter.date(from: two.0)
            return firstDate?.compare(secondDate!) == ComparisonResult.orderedAscending
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter.timeStyle = DateFormatter.Style.noStyle
        dateFormatter.dateStyle = DateFormatter.Style.mediumStyle
        
        try! self.fetchedResultsController.performFetch()
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = arrayOfDates[(indexPath as NSIndexPath).row].0
        cell.detailTextLabel?.text = "\(arrayOfDates[(indexPath as NSIndexPath).row].1) games played."
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        let date = dateFormatter.date(from: (sender as! UITableViewCell).textLabel!.text!)
        let hvc = segue.destinationViewController as! HistoryController
        
        hvc.date = date
        
    }
}
