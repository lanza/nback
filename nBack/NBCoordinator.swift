

protocol NBCoordinator: class, HasWindow, HasContext {
    weak var delegate: CoordinatorDelegate! { get set }
    func start()
    var coordinators: [NBCoordinator] { get set }
}

func ==(lhs: Coordinator, rhs: Coordinator) -> Bool {
    return lhs === rhs
}

class Coordinator: Equatable {
    
    weak var delegate: CoordinatorDelegate?
    
    var viewController: ViewController!
    
    var coordinators = [Coordinator]()
    
    func start() {
        //viewController.delegate = self
    }

    func viewController(_ viewController: ViewController, shouldSegueWith thing: Any?) {}
    func viewController(_ viewController: ViewController, didCancelWith thing: Any?) {}
    func viewController(_ viewController: ViewController, didFinishWith thing: Any?) {}
    
    func removeChild(coordinator: Coordinator) -> Coordinator? {
        guard let index = coordinators.index(of: coordinator) else { return nil }
        return coordinators.remove(at: index)        
    }
}
extension Coordinator: ViewControllerDelegate {}

protocol ViewControllerDelegate: class {
    func viewController(_ viewController: ViewController, shouldSegueWith thing: Any?)
    func viewController(_ viewController: ViewController, didCancelWith thing: Any?)
    func viewController(_ viewController: ViewController, didFinishWith thing: Any?)
}
