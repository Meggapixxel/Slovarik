//
//  GradientView.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

@IBDesignable class V_GradientView: UIView {
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer? { return self.layer as? CAGradientLayer }
    @objc dynamic var colors = [UIColor]() {
        didSet { updateGradient() }
    }
    var direction: Direction = .leftToRight {
        didSet { updateGradient() }
    }
    
    
    // MARK: - Lifecycle
    convenience init() {
        self.init(frame: .zero)
        
    }

    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    
    // MARK: - Public functions
    func setColors(_ colors: [UIColor], animated: Bool, duration: Double = 0.3) {
        let fromColors = self.colors
        self.colors = colors
        guard animated else { return }
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = colors
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.gradientLayer?.add(animation, forKey: "colors")
    }
    
    func updateGradient() {
        gradientLayer?.colors = colors.compactMap { $0.cgColor }
        gradientLayer?.startPoint = direction.startPoint
        gradientLayer?.endPoint = direction.endPoint
    }
    
}

extension V_GradientView {
    
    enum Direction {
        
        case topToBottom
        case leftToRight
        case rightToLeft
        case bottomToTop
        case custom(start: CGPoint, end: CGPoint)
        
        var startPoint: CGPoint {
            switch self {
            case .topToBottom: return CGPoint(x: 0.5, y: 0.0)
            case .leftToRight: return CGPoint(x: 0.0, y: 0.5)
            case .rightToLeft: return CGPoint(x: 1.0, y: 0.5)
            case .bottomToTop: return CGPoint(x: 0.5, y: 1.0)
            case .custom(let start, _): return start
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .topToBottom: return CGPoint(x: 0.5, y: 1.0)
            case .leftToRight: return CGPoint(x: 1.0, y: 0.5)
            case .rightToLeft: return CGPoint(x: 0.0, y: 0.5)
            case .bottomToTop: return CGPoint(x: 0.5, y: 0.0)
            case .custom(_, let end): return end
            }
        }
        
    }
    
}
