import UIKit

extension UIStoryboard {
    
    func initial<T: UIViewController>() -> T? {
        return instantiateInitialViewController() as? T
    }
    
//    func get<T: UIViewController>() -> T? {
//        let identifier = String(describing: T.self)
//        return instantiateViewController(withIdentifier: identifier) as? T
//    }
    
    func get<T: UIViewController>(_ classType: T.Type) -> T? {
        let identifier = String(describing: T.self)
        return instantiateViewController(withIdentifier: identifier) as? T
    }
    
}
