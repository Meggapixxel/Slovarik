//
//  TabManButton.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/28/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

class V_TMButton: UIButton {
    
    @Inject private var appearanceManager: AppearanceManager
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    init(image: UIImage, target: Any?, action: Selector, event: UIControl.Event = .touchUpInside) {
        super.init(frame: .zero)
        setImage(image, for: .normal)
        addTarget(target, action: action, for: event)
        alpha = appearanceManager.blurContentAlpha
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
