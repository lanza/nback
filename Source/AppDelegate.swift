import UIKit
import RealmSwift

import CoreData
class Initializer {
  
  static let defaults = UserDefaults.standard
  
  static func run() {
    if defaults[.hasDoneSetup] == nil {
      GameSettings.setDefaults()
      defaults[.lastScoreString] = "Welcome to nBack"
      defaults[.lastResultString] = ""
      
      defaults[.hasDoneSetup] = true
    }
    
    if defaults[.hasConvertedFromCoreData] == nil {
      
     
      let l = Test()
      l.testEntries()
      
      convertData()
      
      //defaults[.hasConvertedFromCoreData] = true
      
      fatalError()
      
    }
  }
  
  static func convertData() {
    
    let context = CoreData.shared.context
    let gameResults = GameResult.fetch(in: context)
    let typeResults = TypeResult.fetch(in: context)
    
    let r = try! Realm()
    
        try! r.write {
    
          for result in gameResults {
            let gameResultRealm = GameResultRealm.new(columns: Int(result.columns), rows: Int(result.rows), level: Int(result.level), numberOfTurns: Int(result.numberOfTurns), secondsBetweenTurns: result.secondsBetweenTurns, squareHighlightTime: result.squareHighlightTime)
            r.add(gameResultRealm)
    
            for typeResult in result.types {
              let t = TypeResultRealm.new(correct: Int(typeResult.correct), incorrect: Int(typeResult.incorrect), matches: Int(typeResult.matches), falseFalse: Int(typeResult.falseFalse), falseTrue: Int(typeResult.falseTrue), trueFalse: Int(typeResult.trueFalse), trueTrue: Int(typeResult.trueTrue), nBackType: typeResult.type, game: gameResultRealm)
    
              r.add(t)
            }
          }
        }
    
    let gameResultRealms = r.objects(GameResultRealm.self)
    let typeResultRealms = r.objects(TypeResultRealm.self)
    
    let grr = gameResultRealms.count
    let gr = gameResults.count
    
    let trr = typeResultRealms.count
    let tr = typeResults.count
    
    print(grr,gr,trr,tr)
    
        assert(gameResultRealms.count == gameResults.count)
        assert(typeResultRealms.count == typeResults.count)
    
  }
}

class Test {
  let context = CoreData.shared.context
  var date = Date(timeInterval: -1000, since: Date())
  func testEntries() {
    for _ in 1...10000 {
      _ = generateFakeResult()
    }
  }
  
  func generateFakeResult() -> GameResult {
    var result: GameResult! = nil
    context.performAndWait {
      result = GameResult(context: self.context)
      result.initialize(with: Date(timeInterval: Double(Utilities.random(max: 100000000) - 50000000), since: Date()))
      for type in [.squares, .numbers, .colors] as [NBackType] {
        result.types.insert(self.generateFakeType(type))
      }
      self.context.save { Utilities.show(error: $0) }
    }
    return result
  }
  
  func generateFakeType(_ type: NBackType) -> TypeResult {
    let result = TypeResult(context: context)
    
    result.correct = Int16(Utilities.random(max: 10))
    result.incorrect = Int16(Utilities.random(max: 10))
    result.matches = Int16(Utilities.random(max: 10))
    result.type = type
    
    result.falseFalse = Int16(Utilities.random(max: 10))
    result.falseTrue = Int16(Utilities.random(max: 10))
    result.trueFalse = Int16(Utilities.random(max: 10))
    result.trueTrue = Int16(Utilities.random(max: 10))
    
    return result
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  static var main: AppDelegate!
  
  var window: UIWindow?
  var appCoordinator = AppCoordinator()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    AppDelegate.main = self
    
    
    Initializer.run()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootCoordinator = appCoordinator
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
  }
}

