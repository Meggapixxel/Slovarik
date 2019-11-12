import UIKit

extension UIApplication {
    
    static var safeAreaInsets: UIEdgeInsets {
        let insets: UIEdgeInsets?
        if #available(iOS 13.0, *) {
            insets = UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets
        } else if #available(iOS 11.0, *) {
            insets = UIApplication.shared.keyWindow?.safeAreaInsets
        } else {
            insets = UIApplication.shared.keyWindow?.layoutMargins
        }
        return insets ?? .zero
    }
    
}
