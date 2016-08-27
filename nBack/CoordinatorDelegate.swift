import Foundation

protocol CoordinatorDelegate: class {
    func coordinatorIsDone(_ coordinator: NBCoordinator)
    var coordinators: [NBCoordinator] { get set }
}
extension CoordinatorDelegate {
    func coordinatorIsDone(_ coordinator: NBCoordinator) {
        let index = coordinators.index { $0 === coordinator }!
        coordinators.remove(at: index)
    }
}
