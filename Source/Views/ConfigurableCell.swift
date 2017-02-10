import Foundation

protocol ConfigurableCell {
    associatedtype Object
    func configure(for object: Object, indexPath: IndexPath)
}
