import CoreData
import SwiftUI
import UIKit

extension NSManagedObject {
  func shallowCopy() -> Self? {
    guard let context = managedObjectContext, let entityName = entity.name
    else { return nil }
    let copy = NSEntityDescription.insertNewObject(
      forEntityName: entityName, into: context)
    let attributes = entity.attributesByName
    for (attrKey, _) in attributes {
      copy.setValue(value(forKey: attrKey), forKey: attrKey)
    }
    guard let new = copy as? Self else {
      fatalError("This should work.")
    }
    return new
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  static var main: AppDelegate!

  var window: UIWindow?
  var appCoordinator = AppCoordinator()
  var useSwiftUI = false

  func firstRunSync() {
    let context = CoreData.shared.context
    let days = Day.fetch(in: context)

    context.performAndWait {
      for day in days {
        guard let dayCopy = day.shallowCopy() else {
          fatalError("IDK")
        }
        for gameResult in day.results {
          guard let gameResultCopy = gameResult.shallowCopy() else {
            fatalError("IDK2")
          }
          for typeResult in gameResult.types {
            guard let typeResultCopy = typeResult.shallowCopy() else {
              fatalError("IDK3")
            }
            gameResultCopy.types.insert(typeResultCopy)
            typeResultCopy.game = gameResultCopy
            context.delete(typeResult)
          }
          gameResultCopy.dayPlayed = dayCopy
          dayCopy.results.insert(gameResultCopy)
          context.delete(gameResult)
        }
        context.delete(day)
      }

      context.save(errorHandler: nil)
    }
  }

  func dumpJson() {
    let context = CoreData.shared.context
    let days = Day.fetch(in: context)

    let json = try! JSONEncoder().encode(days)
    print(String(data: json, encoding: .utf8)!)
  }

  func dedup() {
    let context = CoreData.shared.context
    let days = Day.fetch(in: context)

    func deduper(days: [Day]) -> Day? {
      for (index, day1) in days.enumerated() {
        var copy = days
        let _ = copy.remove(at: index)
        assert(copy.count == days.count - 1)
        for day2 in copy {
          if day1.date == day2.date {
            for gameResult in day2.results {
              for typeResult in gameResult.types {
                context.delete(typeResult)
              }
              context.delete(gameResult)
            }
            context.delete(day2)
            return day2
          }
        }
      }
      return nil
    }
    context.performAndWait {
      var days2 = days
      while let duped = deduper(days: days2) {
        guard let index = days2.firstIndex(of: duped) else { fatalError("HI") }
        days2.remove(at: index)
      }

      context.save(errorHandler: nil)
    }
  }

  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppDelegate.main = self

    let key = "hasPerformedMigration"
    if UserDefaults.standard.bool(forKey: key) {
      firstRunSync()
      UserDefaults.standard.set(true, forKey: key)
    }

    if !useSwiftUI {
      UIViewController.performSwizzling()
      UIWindow.performSwizzling()

      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootCoordinator = appCoordinator
    }
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(
      name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // Called when the user discards a scene session.  If any sessions were
    // discarded while the application was not running, this will be called
    // shortly after application:didFinishLaunchingWithOptions.  Use this method
    // to release any resources that were specific to the discarded scenes, as
    // they will not return.
  }

}
