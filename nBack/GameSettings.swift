import Foundation

struct GameSettings {
    static var shared: GameSettings {
        return GameSettings()
    }
    private init() { }
    private var defaults = UserDefaults.standard
    var squareHighlightTime: Double {
        get { return defaults.object(forKey: Lets.squareHighlightTimeKey) as? Double ?? 0.5 }
        set { defaults.set(newValue, forKey: Lets.squareHighlightTimeKey) }
    }
    var timeBetweenTurns: Double {
        get { return defaults.object(forKey: Lets.timeBetweenTurnsKey) as? Double ?? 3.0 }
        set { defaults.set(newValue, forKey: Lets.timeBetweenTurnsKey) }
    }
    var types: [GameType] {
        get { return (defaults.object(forKey: Lets.typesKey) as? Set<Int> ?? [0,1,2]).map { GameType.fromDefaults(value: $0) } }
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
