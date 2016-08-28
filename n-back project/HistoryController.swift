import UIKit
import CoreData

var dateFormatter = DateFormatter()

class HistoryController: UITableViewController, NSFetchedResultsControllerDelegate {

    var date: Date!
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    }

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        try! fetchedResultsController.performFetch()
        tableView.reloadData()
    }
    
    // MARK: - FetchedResultsController setup
    
    var frc: NSFetchedResultsController<GameResult>!
    
    
    var fetchedResultsController: NSFetchedResultsController<GameResult> {
        if frc != nil {
            return frc
        }
        
        let fetchRequest = NSFetchRequest<GameResult>()
        let entity = NSEntityDescription.entity(forEntityName: "GameResult", in: self.context)
        fetchRequest.entity = entity
        
        var comps = DateComponents()
        let calendar = Calendar.current
        comps.day = calendar.component(.day, from: self.date)
        comps.month = calendar.component(.month, from: self.date)
        comps.year = calendar.component(.year, from: self.date)
        
        let beginningDate = calendar.date(from: comps)
        let endingDate = beginningDate!.addingTimeInterval(60*60*24)
        
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleGameHistoryCell
        
        let result  = fetchedResultsController.object(at: indexPath) 
        
        cell.dateLabel.text = result.dateString
        cell.scoreLabel.text = result.scoreString
        cell.backAndTurnsLabel.text = result.backAndTurnsString
        
       
        

        
    
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: selectedCell)!
        let ohc = segue.destination as! OneHistoryController
        ohc.gameResult = fetchedResultsController.object(at: indexPath) 
    }

}
