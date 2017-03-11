import Foundation
import SwiftyJSON

class JSONParser {
    
    static func parse() {
        
        let url = Bundle.main.url(forResource: "oldData", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        
        let anyJSON = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let json = JSON(anyJSON)
       
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        
        print(json.arrayValue.count)
        
        for gameResultDict in json.array! {
            let numberOfTurns = gameResultDict["numberOfTurns"].int!
            let level = gameResultDict["level"].int!
            let timeBetweenTurns = gameResultDict["timeBetweenTurns"].int!
            let dateString = gameResultDict["date"].string!
            print(dateString)
            let date = df.date(from: dateString)!
            print(date)
            
            let gr = GameResultRealm.new(columns: 3, rows: 3, level: level, numberOfTurns: numberOfTurns, secondsBetweenTurns: Double(timeBetweenTurns), squareHighlightTime: 0.5)
            try! gr.realm?.write {
                gr.date = date
            }
           
            let typeResults = gameResultDict["types"].array!
            for typeResultDict in typeResults {
                
                let correct = typeResultDict["correct"].int!
                let incorrect = typeResultDict["incorrect"].int!
                let matches = typeResultDict["matches"].int!
                let typeInt = typeResultDict["type"].int!
                let type: NBackType = typeInt == 1 ? .squares : .numbers
                
                let tr = TypeResultRealm.new(c: correct, i: incorrect, m: matches, nBackType: type)
                gr.add(typeResult: tr)
            }
            
        }
        
    }
}

import RealmSwift
fileprivate extension TypeResultRealm {
    
    static func new(c: Int, i: Int, m: Int, nBackType: NBackType) -> TypeResultRealm {
    
    let realm = try! Realm()
    
    let t = TypeResultRealm()
    
    try! realm.write {
      
      t.correct = c
      t.incorrect = i
      
      t.matches = m
      
      t.nBackType = nBackType
      
      realm.add(t)
    }
    return t
  }
}
