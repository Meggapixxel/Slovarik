import UIKit

class ChromaColorPicker: UIControl {
    
    private(set) lazy var hexLabel: UILabel = {
        let hexLabel = UILabel()
        hexLabel.textAlignment = .center
        hexLabel.layer.cornerRadius = 2
        hexLabel.adjustsFontSizeToFitWidth = true
        hexLabel.textColor = UIColor.white.withAlphaComponent(0.2)
        return hexLabel
    }()
    private(set) lazy var shadeSlider: ChromaShadeSlider = {
        let shadeSlider = ChromaShadeSlider()
        shadeSlider.delegate = self
        shadeSlider.addTarget(self, action: #selector(ChromaColorPicker.sliderEditingDidEnd(_:)), for: .editingDidEnd)
        return shadeSlider
    }()
    private(set) lazy var handleView: ChromaHandle = {
        let handleView = ChromaHandle(frame: CGRect(x: 0, y: 0, width: handleSize.width, height: handleSize.height))
        handleView.circleLayer.shadowColor = UIColor.black.cgColor
        handleView.circleLayer.shadowRadius = 3
        handleView.circleLayer.shadowOpacity = 0.3
        handleView.circleLayer.shadowOffset = CGSize(width: 0, height: 2)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ChromaColorPicker.handleWasMoved(_:)))
        handleView.addGestureRecognizer(panRecognizer)
        return handleView
    }()
    private(set) lazy var handleLine: CAShapeLayer = {
        let handleLine = CAShapeLayer()
        handleLine.lineWidth = 2
        handleLine.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        return handleLine
    }()
    private(set) lazy var previewColorView: UIView = UIView()
    private(set) var currentColor = UIColor.red
    private var currentAngle: Float = 0
    private(set) var radius: CGFloat = 0
    var stroke: CGFloat = 1
    var padding: CGFloat = 15
    var handleSize: CGSize {
        get {
            let minValue = min(bounds.width, bounds.height)
            let value = minValue * 0.1
            return CGSize(width: value, height: value)
        }
    }
    
    //MARK: BEGIN - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    //MARK: END - Initialization
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        
        radius = (min(bounds.size.width, bounds.size.height) - handleSize.width) / 2
        
        _ = handleView
        layoutPreviewColorView()
        _ = handleLine
        layoutHexLabel()
        layoutShadeSlider()
        
        layer.addSublayer(handleLine)
        addSubview(shadeSlider)
        addSubview(hexLabel)
        addSubview(handleView)
        addSubview(previewColorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        /* Get the starting color */
        currentColor = colorOnWheelFromAngle(currentAngle)
        handleView.center = positionOnWheelFromAngle(currentAngle) // update pos for angle
        layoutHandleLine() // layout the lines positioning
        
        handleView.color = currentColor
        previewColorView.backgroundColor = currentColor
        shadeSlider.primaryColor = currentColor
        updateHexLabel() // update for hex value
    }

    
    // MARK: BEGIN - Handle Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Overriden to prevent uicontrolevents being called from the super
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first!.location(in: self)
        guard handleView.frame.contains(touchPoint) else { return }
        sendActions(for: .touchDown)
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseIn,
            animations: { self.handleView.transform = CGAffineTransform(scaleX: 1.45, y: 1.45) },
            completion: nil
        )
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Run this animation after a pan or here if touches are released
        if handleView.transform.d > 1 { // if scale is larger than 1 (already animated)
            executeHandleShrinkAnimation()
        }
    }
    // MARK: END - Handle Touches
    
    
    // MARK: BEGIN - Actions
    @objc func handleWasMoved(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let touchPosition = recognizer.location(in: self)
            moveHandleTowardPoint(touchPosition)
            sendActions(for: .touchDragInside)
        case .ended:
            /* Shrink Animation */
            executeHandleShrinkAnimation()
        default: break
        }
    }
    
    @objc func sliderEditingDidEnd(_ sender: ChromaShadeSlider) {
        sendActions(for: .editingDidEnd)
    }
    // MARK: END - Actions
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ctx = UIGraphicsGetCurrentContext()
        drawCircleRing(in: ctx, outerRadius: radius - padding, innerRadius: radius - stroke - padding, resolution: 1)
    }
    
    //MARK: - Layout Updates
    /* Re-layout view and all its subview and drawings */
    func layout() {
        setNeedsDisplay() //mark view as dirty
        
        let minDimension = min(bounds.size.width, bounds.size.height)
        radius = (minDimension - handleSize.width) / 2 //create radius for new size
        
        layoutPreviewColorView()
        
        //Update handle's size
        handleView.frame = CGRect(origin: .zero, size: handleSize)
        layoutHandle()
        
        //Ensure colors are updated
        updateCurrentColor(handleView.color)
        shadeSlider.primaryColor = handleView.color
        
        layoutShadeSlider()
        layoutHandleLine()
        layoutHexLabel()
    }
    
    func layoutPreviewColorView() {
        let minValue = min(bounds.width, bounds.height)
        let value = minValue / 5
        let previewColorViewSize = CGSize(width: value, height: value)
        previewColorView.layer.cornerRadius = value / 2
        previewColorView.layer.masksToBounds = true
        previewColorView.frame = CGRect(
            x: bounds.midX - previewColorViewSize.width / 2,
            y: bounds.midY - previewColorViewSize.height / 2,
            width: previewColorViewSize.width,
            height: previewColorViewSize.height
        )
    }
    
    /*
     Update the handleView's position and color for the currentAngle
     */
    func layoutHandle() {
        let angle = currentAngle // Preserve value in case it changes
        let newPosition = positionOnWheelFromAngle(angle) // find the correct position on the color wheel
        
        //Update handle position
        handleView.center = newPosition
        handleView.color = colorOnWheelFromAngle(angle)
    }
    
    /*
     Updates the line view's position for the current angle
     Pre: dependant on addButtons position & current angle
     */
    func layoutHandleLine() {
        let linePath = UIBezierPath()
        linePath.move(to: previewColorView.center)
        linePath.addLine(to: positionOnWheelFromAngle(currentAngle))
        handleLine.path = linePath.cgPath
    }
    
    /*
     Pre: dependant on addButtons position
     */
    func layoutHexLabel() {
        hexLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: previewColorView.bounds.width * 1.5,
            height: previewColorView.bounds.height / 3
        )
        hexLabel.center = CGPoint(
            x: bounds.midX,
            y: (previewColorView.frame.origin.y + padding + (handleView.frame.height + stroke) / 2) / 1.75
        ) // Divided by 1.75 not 2 to make it a bit lower
        hexLabel.font = UIFont.systemFont(ofSize: hexLabel.bounds.height)
    }
    
    /*
     Pre: dependant on radius
     */
    func layoutShadeSlider() {
        /* Calculate proper length for slider */
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let insideRadius = radius - padding
        
        let pointLeft = CGPoint(
            x: centerPoint.x + insideRadius * CGFloat(cos(7 * Double.pi / 6)),
            y: centerPoint.y - insideRadius * CGFloat(sin(7 * Double.pi / 6))
        )
        let pointRight = CGPoint(
            x: centerPoint.x + insideRadius * CGFloat(cos(11 * Double.pi / 6)),
            y: centerPoint.y - insideRadius * CGFloat(sin(11 * Double.pi / 6))
        )
        let deltaX = pointRight.x - pointLeft.x //distance on circle between points at 7pi/6 and 11pi/6
        
        
        let sliderSize = CGSize(
            width: deltaX * 0.75,
            height: 0.08 * (bounds.height - padding * 2)
        )
        shadeSlider.frame = CGRect(
            x: bounds.midX - sliderSize.width / 2,
            y: pointLeft.y - sliderSize.height / 2,
            width: sliderSize.width,
            height: sliderSize.height
        )
        shadeSlider.handleCenterX = shadeSlider.bounds.width / 2
        shadeSlider.layoutLayerFrames()
    }
    
    func updateHexLabel() {
        hexLabel.text = String(format: "#%@", currentColor.hexCode)
    }
    
    func updateCurrentColor(_ color: UIColor) {
        currentColor = color
        previewColorView.backgroundColor = color
        sendActions(for: .valueChanged)
    }
    
}


// MARK: BEGIN - Private Methods
extension ChromaColorPicker {
    
    /*
     Resolution should be between 0.1 and 1
     colorSpace - either rainbow or grayscale
     */
    private func drawCircleRing(in context: CGContext?, outerRadius: CGFloat, innerRadius: CGFloat, resolution: Float) {
        context?.saveGState()
        context?.translateBy(x: bounds.midX, y: bounds.midY) //Move context to center
        
        let subdivisions:CGFloat = CGFloat(resolution * 512) //Max subdivisions of 512
        
        let innerHeight = (CGFloat.pi * innerRadius) / subdivisions //height of the inner wall for each segment
        let outterHeight = (CGFloat.pi * outerRadius) / subdivisions
        
        let segment = UIBezierPath()
        segment.move(to: CGPoint(x: innerRadius, y: -innerHeight / 2))
        segment.addLine(to: CGPoint(x: innerRadius, y: innerHeight / 2))
        segment.addLine(to: CGPoint(x: outerRadius, y: outterHeight / 2))
        segment.addLine(to: CGPoint(x: outerRadius, y: -outterHeight / 2))
        segment.close()
        
        
        //Draw each segment and rotate around the center
        for i in 0 ..< Int(ceil(subdivisions)) {
            
            UIColor(hue: CGFloat(i)/subdivisions, saturation: 1, brightness: 1, alpha: 1).set()
            
            segment.fill()
            let lineTailSpace = (CGFloat.pi * 2) * outerRadius / subdivisions  //The amount of space between the tails of each segment
            segment.lineWidth = lineTailSpace //allows for seemless scaling
            segment.stroke()
            
            //Rotate to correct location
            let rotate = CGAffineTransform(rotationAngle: -(CGFloat.pi * 2) / subdivisions) //rotates each segment
            segment.apply(rotate)
        }
        
        context?.translateBy(x: -bounds.midX, y: -bounds.midY) //Move context back to original position
        context?.restoreGState()
    }
    
    private func executeHandleShrinkAnimation() {
        sendActions(for: .touchUpInside)
        sendActions(for: .editingDidEnd)
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseOut,
            animations: { self.handleView.transform = CGAffineTransform(scaleX: 1, y: 1) },
            completion: nil
        )
    }
    
    private func moveHandleTowardPoint(_ point: CGPoint) {
        currentAngle = angleToCenterFromPoint(point) // Find the angle of point to the frames center
        layoutHandle()
        layoutHandleLine()
        
        // Update color for shade slider
        shadeSlider.primaryColor = handleView.color // currentColor
        
        // Update color for add button if a shade isnt selected
        if shadeSlider.currentValue == 0 {
            updateCurrentColor(shadeSlider.currentColor)
        }
        
        // Update Text Field display value
        updateHexLabel()
    }
    
    private func angleToCenterFromPoint(_ point: CGPoint) -> Float {
        let deltaX = Float(bounds.midX - point.x)
        let deltaY = Float(bounds.midY - point.y)
        let angle = atan2f(deltaX, deltaY)
        
        // Convert the angle to be between 0 and 2PI
        var adjustedAngle = angle + Float.pi / 2
        if (adjustedAngle < 0) { // Left side (Q2 and Q3)
            adjustedAngle += Float.pi * 2
        }
        
        return adjustedAngle
    }
    
    /* Find the angle relative to the center of the frame and uses the angle to find what color lies there */
    private func colorOnWheelFromAngle(_ angle: Float) -> UIColor {
        return UIColor(hue: CGFloat(Double(angle) / (2 * Double.pi)), saturation: 1, brightness: 1, alpha: 1)
    }
    
    private func angleForColor(_ color: UIColor) -> Float {
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return Float(hue * CGFloat.pi * 2)
    }
    
    /* Returns a position centered on the wheel for a given angle */
    private func positionOnWheelFromAngle(_ angle: Float) -> CGPoint {
        let buffer = padding + stroke / 2
        return CGPoint(
            x: bounds.midX + (radius - buffer) * CGFloat(cos(-angle)),
            y: bounds.midY + (radius - buffer) * CGFloat(sin(-angle))
        )
    }
    
}
// MARK: END - Private Methods


// MARK: BEGIN - ChromaShadeSliderDelegate
extension ChromaColorPicker: ChromaShadeSliderDelegate {
    
    public func shadeSliderChoseColor(_ slider: ChromaShadeSlider, color: UIColor) {
        updateCurrentColor(color) // update main controller for selected color
        updateHexLabel()
    }
    
}
// MARK: END - ChromaShadeSliderDelegate
