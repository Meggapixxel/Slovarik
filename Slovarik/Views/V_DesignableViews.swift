import UIKit

@IBDesignable class V_DesignableView: UIView { }

@IBDesignable class V_DesignableButton: UIButton { }

@IBDesignable class V_DesignableLabel: UILabel { }

@IBDesignable class V_DesignableImageView: UIImageView { }

@IBDesignable class V_DesignableVisualEffectView: UIVisualEffectView { }

@IBDesignable class V_DesignableTextField: UITextField { }

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor?.uiColor }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { return layer.shadowColor?.uiColor }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
}

extension CGColor {
    
    var uiColor: UIColor { return UIColor(cgColor: self) }
    
}
