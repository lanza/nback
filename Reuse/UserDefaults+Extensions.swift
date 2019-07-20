//import Foundation
//
//public extension UserDefaults {
//  class Proxy {
//    fileprivate let defaults: UserDefaults
//    fileprivate let key: String
//    
//    fileprivate init(_ defaults: UserDefaults, _ key: String) {
//      self.defaults = defaults
//      self.key = key
//    }
//    
//    public var object: Any? {
//      return defaults.object(forKey: key)
//    }
//    public var string: String? {
//      return defaults.string(forKey: key)
//    }
//    public var array: [Any]? {
//      return defaults.array(forKey: key)
//    }
//    public var dictionary: [String: Any]? {
//      return defaults.dictionary(forKey: key)
//    }
//    public var data: Data? {
//      return defaults.data(forKey: key)
//    }
//    public var date: Date? {
//      return object as? Date
//    }
//    public var number: NSNumber? {
//      return defaults.number(forKey: key)
//    }
//    public var int: Int? {
//      return number?.intValue
//    }
//    public var double: Double? {
//      return number?.doubleValue
//    }
//    public var bool: Bool? {
//      return number?.boolValue
//    }
//    public var stringValue: String {
//      return string ?? ""
//    }
//    public var arrayValue: [Any] {
//      return array ?? []
//    }
//    public var dictionaryValue: [String:Any] {
//      return dictionary ?? [:]
//    }
//    public var dataValue: Data {
//      return data ?? Data()
//    }
//    public var numberValue: NSNumber {
//      return number ?? 0
//    }
//    public var intValue: Int {
//      return int ?? 0
//    }
//    public var doubleValue: Double {
//      return double ?? 0
//    }
//    public var boolValue: Bool {
//      return bool ?? false
//    }
//  }
//  
//  func number(forKey key: String) -> NSNumber? {
//    return object(forKey: key) as? NSNumber
//  }
//  public subscript(key: String) -> Proxy {
//    return Proxy(self,key)
//  }
//  public subscript(key: String) -> Any? {
//    get {
//      let proxy: Proxy = self[key]
//      return proxy
//    }
//    set {
//      guard let newValue = newValue else {
//        removeObject(forKey: key)
//        return
//      }
//      
//      switch newValue {
//      case let v as Double: self.set(v, forKey: key)
//      case let v as Int: self.set(v, forKey: key)
//      case let v as Bool: self.set(v, forKey: key)
//      case let v as URL: self.set(v, forKey: key)
//      default: self.set(newValue, forKey: key)
//      }
//    }
//  }
//  
//  public func hasKey(_ key: String) -> Bool {
//    return object(forKey: key) != nil
//  }
//  public func remove(_ key: String) {
//    removeObject(forKey: key)
//  }
//  
//  public func removeAll() {
//    for (key,_) in dictionaryRepresentation() {
//      removeObject(forKey: key)
//    }
//  }
//}
//
//public class DefaultsKeys {
//  fileprivate init() {}
//}
//public class DefaultsKey<ValueType>: DefaultsKeys {
//  public let _key: String
//  public init(_ key: String) {
//    self._key = key
//    super.init()
//  }
//}
//
//extension UserDefaults {
//  public func set<T>(_ key: DefaultsKey<T>, _ value: Any?) {
//    self[key._key] = value
//  }
//}
//
//extension UserDefaults {
//  public func hasKey<T>(_ key: DefaultsKey<T>) -> Bool {
//    return object(forKey: key._key) != nil
//  }
//  
//  public func remove<T>(_ key: DefaultsKey<T>) {
//    removeObject(forKey: key._key)
//  }
//}
//
//extension UserDefaults {
//  public subscript(key: DefaultsKey<String?>) -> String? {
//    get { return string(forKey: key._key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<String>) -> String {
//    get { return string(forKey: key._key) ?? "" }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Int?>) -> Int? {
//    get { return number(forKey: key._key)?.intValue }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Int>) -> Int {
//    get { return number(forKey: key._key)?.intValue ?? 0 }
//    set { set(key, newValue) }
//  }
//  
//  public subscript(key: DefaultsKey<Double?>) -> Double? {
//    get { return number(forKey: key._key)?.doubleValue }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Double>) -> Double {
//    get { return number(forKey: key._key)?.doubleValue ?? 0 }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Bool?>) -> Bool? {
//    get { return number(forKey: key._key)?.boolValue }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Bool>) -> Bool {
//    get { return number(forKey: key._key)?.boolValue ?? false }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Any?>) -> Any? {
//    get { return object(forKey: key._key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Data?>) -> Data? {
//    get { return data(forKey: key._key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Data>) -> Data {
//    get { return data(forKey: key._key) ?? Data() }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<Date?>) -> Date? {
//    get { return object(forKey: key._key) as? Date }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<URL?>) -> URL? {
//    get { return url(forKey: key._key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[String:Any]?>) -> [String:Any]? {
//    get { return dictionary(forKey: key._key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[String:Any]>) -> [String:Any] {
//    get { return dictionary(forKey: key._key) ?? [:] }
//    set { set(key, newValue) }
//  }
//}
//
//extension UserDefaults {
//  
//  public subscript(key: DefaultsKey<[Any]?>) -> [Any]? {
//    get { return array(forKey: key._key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Any]>) -> [Any] {
//    get { return array(forKey: key._key) ?? [] }
//    set { set(key, newValue) }
//  }
//}
//
//extension UserDefaults {
//  public func getArray<T: _ObjectiveCBridgeable>(_ key: DefaultsKey<[T]>) -> [T] {
//    return array(forKey: key._key) as NSArray? as? [T] ?? []
//  }
//  public func getArray<T: _ObjectiveCBridgeable>(_ key: DefaultsKey<[T]?>) -> [T]? {
//    return array(forKey: key._key) as NSArray? as? [T]
//  }
//  public func getArray<T: Any>(_ key: DefaultsKey<[T]>) -> [T] {
//    return array(forKey: key._key) as NSArray? as? [T] ?? []
//  }
//  public func getArray<T: Any>(_ key: DefaultsKey<[T]?>) -> [T]? {
//    return array(forKey: key._key) as NSArray? as? [T]
//  }
//}
//
//extension UserDefaults {
//  public subscript(key: DefaultsKey<[String]?>) -> [String]? {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[String]>) -> [String] {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Int]?>) -> [Int]? {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Int]>) -> [Int] {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Double]?>) -> [Double]? {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Double]>) -> [Double] {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Bool]?>) -> [Bool]? {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Bool]>) -> [Bool] {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Data]?>) -> [Data]? {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Data]>) -> [Data] {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Date]?>) -> [Date]? {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//  public subscript(key: DefaultsKey<[Date]>) -> [Date] {
//    get { return getArray(key) }
//    set { set(key, newValue) }
//  }
//}
//
//extension UserDefaults {
//  public func archive<T: RawRepresentable>(_ key: DefaultsKey<T>, _ value: T) {
//    set(key, value.rawValue)
//  }
//  public func archive<T: RawRepresentable>(_ key: DefaultsKey<T?>, _ value: T?) {
//    if let value = value {
//      set(key, value.rawValue)
//    } else {
//      remove(key)
//    }
//  }
//  
//  public func unarchive<T: RawRepresentable>(_ key: DefaultsKey<T?>) -> T? {
//    return object(forKey: key._key).flatMap { T(rawValue: $0 as! T.RawValue) }
//  }
//  public func unarchive<T: RawRepresentable>(_ key: DefaultsKey<T>) -> T? {
//    return object(forKey: key._key).flatMap { T(rawValue: $0 as! T.RawValue) }
//  }
//}
//
//extension UserDefaults {
//  public func archive<T>(_ key: DefaultsKey<T>, _ value: T) {
//    set(key, NSKeyedArchiver.archivedData(withRootObject: value))
//  }
//  public func archive<T>(_ key: DefaultsKey<T?>, _ value: T?) {
//    if let value = value {
//      set(key, NSKeyedArchiver.archivedData(withRootObject: value))
//    } else {
//      remove(key)
//    }
//  }
//  
//  public func unarchive<T>(_ key: DefaultsKey<T>) -> T? {
//    return data(forKey: key._key).flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) } as? T
//  }
//  public func unarchive<T>(_ key: DefaultsKey<T?>) -> T? {
//    return data(forKey: key._key).flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) } as? T
//  }
//}
