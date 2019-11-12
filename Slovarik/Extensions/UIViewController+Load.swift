import UIKit

extension UIViewController {
    
    func loadAsRoot() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let rootNavigation = appDelegate.window?.rootViewController as? AppNavigationController else { return }
        if rootNavigation.viewControllers.isEmpty {
            rootNavigation.viewControllers = [self]
        } else {
            rootNavigation.viewControllers[0] = self
            rootNavigation.popToRootViewController(animated: true)
        }
    }
    
}
