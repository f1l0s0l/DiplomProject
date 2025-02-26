import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellClass name: T.Type) {
        register(name, forCellWithReuseIdentifier: String(describing: name.self))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(class name: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: name.self), for: indexPath) as! T
    }
    
    func registerHeader<T: UICollectionReusableView>(_ type: T.Type) {
        register(type, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type.self))
    }
    
    func dequeueReusableHeader<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type.self), for: indexPath) as! T
    }
}
