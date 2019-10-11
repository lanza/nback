import Foundation

public enum GameType: Int {
  case numbers = 1
  case squares = 0
  case colors = 2

  var string: String {
    switch self {
    case .numbers: return Lets.numbersl10n
    case .squares: return Lets.squaresl10n
    case .colors: return Lets.colorsl10n
    }
  }

  static func from(value: Int) -> GameType {
    return GameType(rawValue: value)!
  }

  var value: Int {
    return rawValue
  }
}
