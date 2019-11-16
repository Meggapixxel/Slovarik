import UIKit

enum InitiableResource {
    
    case storyboard(storyboard: UIStoryboard)
    case xib
    case manual
    
}

protocol P_InitiableViewController where Self: UIViewController {
    
    static var initiableResource: InitiableResource { get }
    
}

extension P_InitiableViewController {
    
    static var newInstance: Self? {
        switch Self.initiableResource {
        case .storyboard(let storyboard): return storyboard.instantiateViewController(withIdentifier: name) as? Self
        case .xib: return Self.init(nibName: name, bundle: nil)
        case .manual: return Self.init(nibName: nil, bundle: nil)
        }
    }
    
    @discardableResult
    func push(in navigationController: UINavigationController?, animated: Bool = true) -> Self {
        navigationController?.pushViewController(self, animated: animated)
        return self
    }
    
    @discardableResult
    func pop(animated: Bool = true) -> Self {
        navigationController?.popViewController(animated: true)
        return self
    }
    
    @discardableResult
    func present(in viewController: UIViewController?, animated: Bool = true) -> Self {
        viewController?.present(self, animated: animated)
        return self
    }
    
}

extension UIViewController {
    
    @discardableResult
    @objc func push(animated: Bool = true, _ closure: () -> (UIViewController?)) -> UIViewController {
        guard let vc = closure() else { return self }
        navigationController?.pushViewController(vc, animated: animated)
        return self
    }
    
    @discardableResult
    @objc func present(animated: Bool = true, completion: (() -> ())? = nil, _ closure: () -> (UIViewController?)) -> UIViewController {
        guard let vc = closure() else { return self }
        present(vc, animated: animated, completion: completion)
        return self
    }
    
}

extension UINavigationController {
    
    @discardableResult
    @objc override func push(animated: Bool = true, _ closure: () -> (UIViewController?)) -> UIViewController {
        guard let vc = closure() else { return self }
        pushViewController(vc, animated: animated)
        return self
    }
    
    func first<T: UIViewController>() -> T? {
        return viewControllers.first as? T
    }
    
    func first<T: UIViewController>(as type: T.Type) -> T? {
        return first()
    }
    
}
