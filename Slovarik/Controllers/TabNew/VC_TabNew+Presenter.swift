//
//  VC_NewTab+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/12/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

extension VC_TabNew {
    
    class Presenter: BaseJellyPresenter<VC_TabNew> {
        
        override var isKeyboardObserving: Bool { true }
        
        override var animatorHeight: CGFloat {
            return (vc.rootStackView?.frame.height ?? 0) +
                (vc.navigationController?.navigationBar.frame.height ?? 0) +
                (vc.view.safeAreaInsets.bottom)
        }
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            
            vc.navigationItem.leftBarButtonItem = vc.cancelButton
            vc.navigationItem.title = "NEW TAB"
            vc.navigationItem.rightBarButtonItem = vc.saveButton
            vc.saveButton.isEnabled = false
        }
        
        func manageSaveButton() {
            vc.saveButton.isEnabled = vc.tabNameTextField.textTrimmedNonEmpty != nil
        }
        
    }
    
}
