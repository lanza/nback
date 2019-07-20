import Foundation
import Swift

public struct Utilities {
    public static func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max) + 1))
    }

    public static func random(range: CountableRange<Int>) -> Int {
        let max = range.upperBound - 1 - range.lowerBound
        let random = Int(arc4random_uniform(UInt32(max) + 1))
        return random + range.lowerBound
    }

    public static func random(range: CountableClosedRange<Int>) -> Int {
        let max = range.upperBound - range.lowerBound
        let random = Int(arc4random_uniform(UInt32(max) + 1))
        return random + range.lowerBound
    }

    public static func show(error: Error) {
        print("====================ERROR================")
        print(error)
    }
}

extension Sequence {
    func findFirstOccurence(block: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for x in self where block(x) { return x }
        return nil
    }

    func some(block: (Iterator.Element) -> Bool) -> Bool {
        return findFirstOccurence(block: block) != nil
    }

    func all(block: (Iterator.Element) -> Bool) -> Bool {
        return findFirstOccurence { !block($0) } == nil
    }

    func asyncForEachWithCompletion(completion: @escaping (() -> Void), block: (Iterator.Element, () -> Void) -> Void) {
        let group = DispatchGroup()
        let innerCompletion = { group.leave() }
        for x in self {
            group.enter()
            block(x, innerCompletion)
        }
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: completion))
    }

    func filterByType<T>() -> [T] {
        return filter { $0 is T }.map { $0 as! T }
    }
}

extension Sequence where Iterator.Element: AnyObject {
    public func containsObjectIdentical(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}

extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1 ..< count]))
    }

    func slices(size: Int) -> [[Iterator.Element]] {
        var result: [[Iterator.Element]] = []
        for idx in stride(from: startIndex, to: endIndex, by: size) {
            let a: Int = idx + size
            let b: Int = endIndex
            let end = Swift.min(a, b)
            result.append(Array(self[idx ..< end]))
        }
        return result
    }
}

extension URL {
    static func temporaryURL() -> URL {
        return try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(UUID().uuidString)
    }

    static var documentsURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}
