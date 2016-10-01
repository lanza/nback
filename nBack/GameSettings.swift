import Foundation

struct GameSettings {
    static var shared: GameSettings = {
        return GameSettings()
    }()

    private var defaults = UserDefaults.standard
    var squareHighlightTime: Double {
        get { return defaults.object(forKey: Lets.squareHighlightTimeKey) as? Double ?? 1 }
        set { defaults.set(newValue, forKey: Lets.squareHighlightTimeKey) }
    }
    var secondsBetweenTurns: Double {
        get { return defaults.object(forKey: Lets.secondsBetweenTurnsKey) as? Double ?? 3 }
        set { defaults.set(newValue, forKey: Lets.secondsBetweenTurnsKey) }
    }
    var types: [GameType] {
        get { return (defaults.object(forKey: Lets.typesKey) as? [Int] ?? [0,1,2]).map { GameType.from(value: $0) } }
        set { defaults.set(newValue.map { $0.value }, forKey: Lets.typesKey) }
    }
    var level: Int {
        get { return defaults.object(forKey: Lets.levelKey) as? Int ?? 2 }
        set { defaults.set(newValue, forKey: Lets.levelKey) }
    }
    var rows: Int {
        get { return defaults.object(forKey: Lets.rowsKey) as? Int ?? 3 }
        set { defaults.set(newValue, forKey: Lets.rowsKey) }
    }
    var columns: Int {
        get { return defaults.object(forKey: Lets.columnsKey) as? Int ?? 3 }
        set { defaults.set(newValue, forKey: Lets.columnsKey) }
    }
    var numberOfTurns: Int {
        get { return defaults.object(forKey: Lets.numberOfTurnsKey) as? Int ?? 15 }
        set { defaults.set(newValue, forKey: Lets.numberOfTurnsKey) }
    }
}
