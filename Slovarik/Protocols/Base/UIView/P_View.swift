import UIKit

protocol P_View: UIView {

}

extension P_View {
    
    static func instantiateFromNib() -> Self {
        let nib = UINib(nibName: String(describing: Self.self), bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
}

extension UIView: P_View {
    
}

