import RealmSwift

class GameResultRealm: Object {
  
  static func new(columns: Int, rows: Int, level: Int, numberOfTurns: Int, secondsBetweenTurns:Double, squareHighlightTime: Double) -> GameResultRealm {
    
    let realm = try! Realm()
    
    let r = GameResultRealm()
    
    try! realm.write {
      
      r.columns = columns
      r.rows = rows
      r.level = level
      r.numberOfTurns = numberOfTurns
      r.secondsBetweenTurns = secondsBetweenTurns
      r.squareHighlightTime = squareHighlightTime
      
      realm.add(r)
    }
    return r
  }
  
  dynamic var date = Date()
  
  dynamic var columns = 0
  dynamic var rows = 0
  
  dynamic var level = 0
  dynamic var numberOfTurns = 0
  dynamic var secondsBetweenTurns: Double = 0
  dynamic var squareHighlightTime: Double = 0
  
  let types = LinkingObjects(fromType: TypeResultRealm.self, property: "game")
  
  var totalCorrect: Int { return Int(types.map { return $0.correct }.reduce(0) { $0 + $1 }) }
  var totalIncorrect: Int { return Int(types.map { $0.incorrect }.reduce(0) { $0 + $1 }) }
  var percentage: String { return String(Double(totalCorrect) / (Double(totalCorrect + totalIncorrect))) }
   
   func add(typeResult: TypeResultRealm) {
      let r = try! Realm()
      try! r.write {
         typeResult.game = self
      }
   }
}

class TypeResultRealm: Object {
  
   static func new(score: Score, nBackType: NBackType) -> TypeResultRealm {
    
    let realm = try! Realm()
    
    let t = TypeResultRealm()
    
    try! realm.write {
      
      t.correct = score.correct
      t.incorrect = score.incorrect
      
      t.matches = score.matches
      
      t.falseFalse = score.falseFalse
      t.falseTrue = score.falseTrue
      t.trueFalse = score.trueFalse
      t.trueTrue = score.trueTrue
      
      t.nBackType = nBackType
      
      realm.add(t)
    }
    return t
  }
  
  dynamic var correct = 0
  dynamic var incorrect = 0
  
  dynamic var matches = 0
  
  dynamic var falseFalse = 0
  dynamic var falseTrue = 0
  dynamic var trueFalse = 0
  dynamic var trueTrue = 0
  
  dynamic var nBackTypeInt = 0
  
  var nBackType: NBackType {
    get {
      return NBackType(rawValue: nBackTypeInt)!
    }
    set {
      nBackTypeInt = newValue.rawValue
    }
  }
  
  dynamic var game: GameResultRealm?
}
