import Foundation
import Reuse

struct GameSettings {
  
  static func setDefaults() {
    squareHighlightTime = 1
    secondsBetweenTurns = 3
    types = [.squares,.numbers]
    level = 2
    rows = 3
    columns = 3
    numberOfTurns = 15
  }
  
  static private var defaults = UserDefaults.standard
  
  static var squareHighlightTime: Double {
    get { return defaults[.squareHighlightTime] }
    set { defaults[.squareHighlightTime] = newValue }
  }
  static var secondsBetweenTurns: Double {
    get { return defaults[.secondsBetweenTurns] }
    set { defaults[.secondsBetweenTurns] = newValue }
  }
  static var types: Set<NBackType> {
    get { return Set(defaults[.types].map { NBackType.from(value: $0) }) }
    set { defaults[.types] = newValue.map { $0.value } }
  }
  static var level: Int {
    get { return defaults[.level] }
    set { defaults[.level] = newValue }
  }
  static var rows: Int {
    get { return defaults[.rows] }
    set { defaults[.rows] = newValue }
  }
  static var columns: Int {
    get { return defaults[.columns] }
    set { defaults[.columns] = newValue }
  }
  static var numberOfTurns: Int {
    get { return defaults[.numberOfTurns] }
    set { defaults[.numberOfTurns] = newValue }
  }
}

extension DefaultsKeys {
  static let squareHighlightTime = DefaultsKey<Double>(Lets.squareHighlightTimeKey)
  static let secondsBetweenTurns = DefaultsKey<Double>(Lets.secondsBetweenTurnsKey)
  static let types = DefaultsKey<[Int]>(Lets.typesKey)
  static let level = DefaultsKey<Int>(Lets.levelKey)
  static let rows = DefaultsKey<Int>(Lets.rowsKey)
  static let columns = DefaultsKey<Int>(Lets.columnsKey)
  static let numberOfTurns = DefaultsKey<Int>(Lets.numberOfTurnsKey)
}

extension DefaultsKeys {
  static let lastScoreString = DefaultsKey<String>(Lets.lastScoreStringKey)
  static let lastResultString = DefaultsKey<String>(Lets.lastResultStringKey)
}

extension DefaultsKeys {
  static let hasDoneSetup = DefaultsKey<Bool?>(Lets.hasDoneSetupKey)
  static let hasConvertedFromCoreData = DefaultsKey<Bool?>(Lets.hasConvertedFromCoreDataKey)
}
