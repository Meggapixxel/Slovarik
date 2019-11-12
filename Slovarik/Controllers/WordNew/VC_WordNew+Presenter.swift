//
//  VC_NewWord+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/12/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

extension VC_WordNew {
    
    class Presenter: BaseJellyPresenter<VC_WordNew> {
        
        override var isKeyboardObserving: Bool { true }
        
        override var animatorHeight: CGFloat {
            return (vc.rootStackView?.frame.height ?? 0) +
                (vc.navigationController?.navigationBar.frame.height ?? 0) +
                (vc.view.safeAreaInsets.bottom)
        }
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            
            vc.navigationItem.leftBarButtonItem = vc.cancelButton
            vc.navigationItem.title = "NEW WORD"
            vc.navigationItem.rightBarButtonItem = vc.saveButton
            vc.saveButton.isEnabled = false
            vc.tabButton.setTitle(vc.selectedTab.name, for: .normal)
        }
        
        override func runtimeUpdateUI() {
            super.runtimeUpdateUI()
            
            vc.tabButton.setTitle(vc.selectedTab.name, for: .normal)
        }
        
    }
    
}
