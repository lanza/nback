import Foundation
import CoreGraphics

struct Lets {
    static let playl10n = NSLocalizedString("Play", comment: "")
    static let historyl10n = NSLocalizedString("History", comment: "")
    
    static let matchButtonHeight = CGFloat(60)
}

struct GameValues {
    static var squareHighlightTime = 0.5
}

extension Double {
    var nanoseconds: Double {
        return Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}

