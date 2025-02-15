import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellClass name: T.Type) {
        register(name, forCellWithReuseIdentifier: String(describing: name.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(class name: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: name.self), for: indexPath) as! T
    }
}
