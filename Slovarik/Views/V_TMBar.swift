//
//  AppTMBar.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/28/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Tabman

class V_TMBar: TMBar.ButtonBar {
    
    required init() {
        super.init()
        backgroundView.removeFromSuperview() // Remove background because navigation is already customized
        
        layout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.interButtonSpacing = 8
        indicator.weight = .light
        indicator.cornerStyle = .eliptical
        fadesContentEdges = true
        spacing = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
