import Foundation
import Swift

struct Utilities {
    static func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max) + 1))
    }
    static func show(error: Error) {
        print("====================ERROR================")
        print(error)
    }
}
