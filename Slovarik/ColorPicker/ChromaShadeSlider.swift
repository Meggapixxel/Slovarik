import UIKit

class ChromaSliderTrackLayer: CALayer {
    
    let gradient = CAGradientLayer()
    
    override init() {
        super.init()
        gradient.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
        addSublayer(gradient)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ChromaShadeSliderDelegate {
    func shadeSliderChoseColor(_ slider: ChromaShadeSlider, color: UIColor)
}

class ChromaShadeSlider: UIControl {
    
    var currentValue: CGFloat = 0.0 // range of {-1,1}
    
    let trackLayer = ChromaSliderTrackLayer()
    let handleView = ChromaHandle()
    var handleWidth: CGFloat { return bounds.height }
    var handleCenterX: CGFloat = 0.0
    var delegate: ChromaShadeSliderDelegate?
    
    var primaryColor = UIColor.gray {
        didSet {
            changeColorHue(to: currentColor)
            updateGradientTrack(for: primaryColor)
        }
    }
    /* The computed color of the primary color with shading based on the currentValue */
    var currentColor: UIColor {
        get {
            if currentValue < 0 { // darken
                return primaryColor.darkerColor(-currentValue)
            } else if currentValue == 0 { // as is
                return primaryColor
            } else { // lighten
                return primaryColor.lighterColor(currentValue)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = nil
        handleCenterX = bounds.width / 2
        
        trackLayer.backgroundColor = UIColor.blue.cgColor
        trackLayer.masksToBounds = true
        trackLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()] //disable implicit animations
        layer.addSublayer(trackLayer)
        
        handleView.color = UIColor.blue
        handleView.circleLayer.borderWidth = 3
        handleView.isUserInteractionEnabled = false //disable interaction for touch events
        addSubview(handleView)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapRecognized))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
        layoutLayerFrames()
        changeColorHue(to: currentColor)
        updateGradientTrack(for: primaryColor)
    }
    
    override func didMoveToSuperview() {
        updateGradientTrack(for: primaryColor)
    }
    
    func layoutLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: handleWidth / 2, dy: bounds.height / 4)
        trackLayer.cornerRadius = trackLayer.bounds.height / 2
        
        updateGradientTrack(for: primaryColor)
        updateHandleLocation()
        layoutHandleFrame()
    }
    
    // Lays out handle according to the currentValue on slider
    func layoutHandleFrame() {
        handleView.frame = CGRect(
            x: handleCenterX - handleWidth / 2,
            y: (bounds.height - handleWidth) / 2,
            width: handleWidth,
            height: handleWidth
        )
    }
    
    func changeColorHue(to newColor: UIColor) {
        handleView.color = newColor
        if currentValue != 0 { // Don't call delegate if the color hasnt changed
            delegate?.shadeSliderChoseColor(self, color: newColor)
        }
    }
    
    func updateGradientTrack(for color: UIColor) {
        trackLayer.gradient.frame = trackLayer.bounds
        trackLayer.gradient.startPoint = CGPoint(x: 0, y: 0.5)
        trackLayer.gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Gradient is for astetics - the slider is actually between black and white
        trackLayer.gradient.colors = [
            color.darkerColor(1).cgColor,
            color.cgColor,
            color.lighterColor(1).cgColor
        ]
    }
    
    // Updates handeles location based on currentValue
    func updateHandleLocation() {
        handleCenterX = (currentValue + 1) / 2 * (bounds.width - handleView.bounds.width) +  handleView.bounds.width / 2
        handleView.color = currentColor
        layoutHandleFrame()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        return handleView.frame.contains(location)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        //Update for center point
        handleCenterX = location.x
        handleCenterX = fittedValueInBounds(handleCenterX) //adjust value to fit in bounds if needed
        
        
        //Update current value
        currentValue = ((handleCenterX - handleWidth / 2) / trackLayer.bounds.width - 0.5) * 2  //find current value between {-1,1} of the slider
        
        //Update handle color
        changeColorHue(to: currentColor)
        
        //Update layers frames
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layoutHandleFrame()
        CATransaction.commit()
        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sendActions(for: .editingDidEnd)
    }
    
    @objc func doubleTapRecognized(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        guard handleView.frame.contains(location) else { return }
        //Tap is on handle
        
        resetHandleToCenter()
    }
    
    func resetHandleToCenter() {
        handleCenterX = bounds.width / 2
        layoutHandleFrame()
        handleView.color = primaryColor
        currentValue = 0
        
        sendActions(for: .valueChanged)
        delegate?.shadeSliderChoseColor(self, color: currentColor)
    }
    
    /* Helper Methods */
    //Returns a CGFloat for the highest/lowest possble value such that it is inside the views bounds
    private func fittedValueInBounds(_ value: CGFloat) -> CGFloat {
        return min(max(value, trackLayer.frame.minX), trackLayer.frame.maxX)
    }
    
}
