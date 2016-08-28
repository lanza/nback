import UIKit
import CoreData


class ViewController: UIViewController {
    var frc: NSFetchedResultsController<GameResult>!
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSFetchRequest<GameResult>(entityName: "GameResult")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        try! frc.performFetch()
        
        convertFile()
    }
    
    func convertFile() {
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "json", ofType: "txt")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
        
        for result in json {
            print(result["date"])
        }
        
        
        
    }
    
    func thing() {
        let dict = (frc.fetchedObjects!).map { result -> [String : Any] in
            var dict = [String : Any]()
            dict["date"] = "\(result.date!)"
            dict["level"] = result.nbackLevel
            dict["numberOfTurns"] = result.numberOfTurns
            dict["timeBetweenTurns"] = result.secondsBetweenTurns
            dict["types"] = [[String : Any]]()
            for type in result.backTypes {
                var subDict = [String : Any]()
                subDict["type"] = type.backType
                subDict["correct"] = type.correct
                subDict["incorrect"] = type.incorrect
                subDict["matches"] = type.matches
                dict["types"] = (dict["types"] as! [[String : Any]]) + [subDict]
            }
            return dict
        }
        
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
        let string = String(data: data, encoding: .utf8)
        
        print("===========================================================================================")
        print(string!)
        print("===========================================================================================")
    }
}
