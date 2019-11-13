//
//  GradientWindow.swift
//  DictYourWay
//
//  Created by Vadim Zhydenko on 10/9/18.
//  Copyright © 2018 Vadim Zhydenko. All rights reserved.
//

import UIKit

class V_GradientWindow: UIWindow {

    private let gradientScrollView = UIScrollView()
    private let solidView = UIView()
    private let gradientView = V_GradientView()
    private let alphaView = UIView(frame: UIScreen.main.bounds)
    private lazy var gradientViewWidthConstraints = gradientView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(solidView)
        solidView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                solidView.leadingAnchor.constraint(equalTo: leadingAnchor),
                solidView.trailingAnchor.constraint(equalTo: trailingAnchor),
                solidView.topAnchor.constraint(equalTo: topAnchor),
                solidView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        solidView.isHidden = true
        
        
        addSubview(gradientScrollView)
        gradientScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                gradientScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                gradientScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                gradientScrollView.topAnchor.constraint(equalTo: topAnchor),
                gradientScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        
        gradientScrollView.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                gradientView.leadingAnchor.constraint(equalTo: gradientScrollView.leadingAnchor),
                gradientView.trailingAnchor.constraint(equalTo: gradientScrollView.trailingAnchor),
                gradientView.topAnchor.constraint(equalTo: gradientScrollView.topAnchor),
                gradientView.bottomAnchor.constraint(equalTo: gradientScrollView.bottomAnchor),
                gradientView.heightAnchor.constraint(equalTo: gradientScrollView.heightAnchor),
                gradientViewWidthConstraints
            ]
        )
        
        addSubview(alphaView)
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                alphaView.leadingAnchor.constraint(equalTo: leadingAnchor),
                alphaView.trailingAnchor.constraint(equalTo: trailingAnchor),
                alphaView.topAnchor.constraint(equalTo: topAnchor),
                alphaView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    func setColors(_ colors: [String], animated: Bool) {
        if colors.count > 1 {
            solidView.isHidden = true
            gradientScrollView.isHidden = false
            gradientView.setColors(colors.compactMap { $0.hexUIColor }, animated: animated)
        } else {
            gradientScrollView.isHidden = true
            solidView.isHidden = false
            solidView.backgroundColor = colors.first?.hexUIColor
        }
    }
    
    func scrollGradientView(toPagePosition pagePosition: CGFloat) {
        guard !gradientScrollView.isHidden else { return }
        gradientScrollView.contentOffset.x = UIScreen.main.bounds.width * pagePosition
    }
    
    func resizeGradientView(withMultiplier multiplier: CGFloat) {
        guard !gradientScrollView.isHidden else { return }
        gradientViewWidthConstraints.constant = UIScreen.main.bounds.width * multiplier
    }

}
