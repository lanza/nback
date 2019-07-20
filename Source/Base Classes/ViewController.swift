import UIKit

class ViewController: UIViewController {
    init() { super.init(nibName: nil, bundle: nil) }

    required init?(coder _: NSCoder) { fatalError() }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
}
