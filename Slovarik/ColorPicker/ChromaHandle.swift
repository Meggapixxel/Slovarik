import UIKit

class ChromaHandle: UIView {
    
    var color = UIColor.black {
        didSet { circleLayer.fillColor = color.cgColor }
    }
    override var frame: CGRect {
        didSet { layoutCircleLayer() }
    }
    var circleLayer = CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.clear
        
        layoutCircleLayer()
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.fillColor = color.cgColor
        
        layer.addSublayer(circleLayer)
    }
    
    func layoutCircleLayer() {
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = frame.width / 8.75
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
