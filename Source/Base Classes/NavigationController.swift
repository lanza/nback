import UIKit

class NavigationController: UINavigationController {
  init(viewController: UIViewController) {
    super.init(rootViewController: viewController)
    tabBarItem = viewController.tabBarItem
  }

  required init?(coder _: NSCoder) { fatalError() }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
}
