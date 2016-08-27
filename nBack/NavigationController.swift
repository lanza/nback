import UIKit

class NavigationController: UINavigationController {
    init(viewController: UIViewController) {
        super.init(rootViewController: viewController)
        tabBarItem = viewController.tabBarItem
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    //override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) { fatalError() }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        print(nibNameOrNil, nibBundleOrNil)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
