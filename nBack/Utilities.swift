import Foundation

struct Utilities {
    static func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max) + 1))
    }
}
