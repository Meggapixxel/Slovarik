import UIKit

extension UITableView {
    
    func register<T: UITableViewHeaderFooterView>(headerFooter: T.Type, reuseIdentifier: String = String(describing: T.self)) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    func new<T: UITableViewHeaderFooterView>(headerFooter: T.Type, reuseIdentifier: String = String(describing: T.self)) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as! T
    }
    
    func register<T: UITableViewCell>(_ classType: T.Type, reuseIdentifier: String = String(describing: T.self)) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func new<T: UITableViewCell>(_ classType: T.Type, reuseIdentifier: String = String(describing: T.self)) -> T {
        return dequeueReusableCell(withIdentifier: reuseIdentifier) as! T
    }
    
    func get<T: UITableViewCell>(_ classType: T.Type, atIndexPath indexPath: IndexPath) -> T? {
        return cellForRow(at: indexPath) as? T
    }
    
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ classType: T.Type, reuseIdentifier: String = String(describing: T.self)) {
        let name = String(describing: T.self)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func new<T: UICollectionViewCell>(_ classType: T.Type, reuseIdentifier: String = String(describing: T.self), indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }
    
    func get<T: UICollectionViewCell>(_ classType: T.Type, atIndexPath indexPath: IndexPath) -> T? {
        return cellForItem(at: indexPath) as? T
    }
    
}
