import UIKit

class SquareView: UIView {

    init() {
        super.init(frame: CGRect())
        backgroundColor = Theme.Colors.normalSquare.color
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
