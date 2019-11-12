//
//  GrowingTextView.swift
//  SmartDict
//
//  Created by Vadim Zhydenko on 2/21/18.
//  Copyright © 2018 Vadim Zhydenko. All rights reserved.
//

import UIKit

@IBDesignable
class V_TextViewWithPlaceholder: UITextView {
    
    @IBInspectable var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable dynamic var placeholderColor: UIColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var attributedPlaceholder: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    override open var text: String! {
        didSet { setNeedsDisplay() }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    
    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard text.isEmpty else { return }
        
        let xValue = textContainerInset.left + textContainer.lineFragmentPadding
        let yValue = textContainerInset.top
        let width = rect.size.width - xValue - textContainerInset.right
        let height = rect.size.height - yValue - textContainerInset.bottom
        let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
        
        if let attributedPlaceholder = attributedPlaceholder {
            attributedPlaceholder.draw(in: placeholderRect)
        } else if let placeholder = placeholder {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            var attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: placeholderColor,
                .paragraphStyle: paragraphStyle
            ]
            if let font = font { attributes[.font] = font }
            placeholder.draw(in: placeholderRect, withAttributes: attributes)
        }
    }
    
    @objc func textDidChange(notification: Notification) {
        guard let sender = notification.object as? V_TextViewWithPlaceholder, sender == self else { return }
        setNeedsDisplay()
    }
    
}
