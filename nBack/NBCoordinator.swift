

protocol NBCoordinator: class, HasWindow, HasContext {
    weak var delegate: CoordinatorDelegate! { get set }
    func start()
    var coordinators: [NBCoordinator] { get set }
}

