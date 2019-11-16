//
//  TabsVC+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/30/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_Tabs {
    
    class Presenter: BaseViewControllerPresenter<VC_Tabs> {
        
        override var isKeyboardObserving: Bool { return true }
        
        override func initialUpdateUI() {
            guard let vc = vc else { return }
            
            vc.dataSource = vc
            vc.bar.leftPinnedAccessoryView = vc.barAddTabButton
            vc.bar.rightPinnedAccessoryView = UIStackView(arrangedSubviews: [vc.barEditTabsButton, vc.barCancelSearchButton])
            vc.barCancelSearchButton.isHidden = true
            vc.addBar(vc.bar, dataSource: vc, at: .navigationItem(item: vc.navigationItem))
            vc.bounces = false
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            vc.bottomDefaultBar.tintColor = UIColor.secondaryLabel
            vc.bar.buttons.customize {
                $0.selectedTintColor = .label
                $0.tintColor = UIColor.secondaryLabel
            }
            vc.bar.indicator.tintColor = .label
            vc.bar.tintColor = .label
        }
        
        override func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
            guard vc.isSearch, vc.bottomSearchBar.isFirstResponder, height > vc.bottomSearchBar.frame.height else { return }
            vc.keyboardHeight = height - vc.bottomSearchBar.frame.height
            vc.bottomSearchBar.setState(.expanded, animation: .some(duration, options))
            vc.view.setNeedsLayout()
        }
        
        override func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) {
            vc.bottomSearchBar.setState(.collapsed, animation: .some(duration, options))
            vc.keyboardHeight = 0
            vc.view.setNeedsLayout()
        }
        
    }
    
}
