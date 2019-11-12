//
//  VC_Auth+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/12/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_Auth {
    
    class Presenter: BaseViewControllerPresenter<VC_Auth> {
        
        override var isNavigationBarHidden: Bool { return true }
        override var isKeyboardObserving: Bool { return true }
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            
            vc.signInButton.isEnabled = true
            vc.signUpButton.isEnabled = true
        }
        
        override func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
            guard let vc = vc else { return }
            vc.scrollView.contentInset.bottom = height

            var visibleRect = CGRect.zero
            if vc.signInContainerStackView.frame.origin.x > vc.scrollView.contentOffset.x {
                visibleRect.origin.x = vc.signInView.frame.origin.x
                visibleRect.origin.y = vc.signInContainerStackView.frame.origin.y
                visibleRect.size = vc.signInContainerStackView.frame.size
            } else {
                visibleRect.origin.x = vc.signUpView.frame.origin.x
                visibleRect.origin.y = vc.signUpContainerStackView.frame.origin.y
                visibleRect.size = vc.signUpContainerStackView.frame.size
            }
            vc.scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
        
        override func keyboardWillChangeFrame(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
            guard let vc = vc else { return }
            vc.scrollView.contentInset.bottom = height

            var visibleRect = CGRect.zero
            if vc.signInContainerStackView.frame.origin.x > vc.scrollView.contentOffset.x {
                visibleRect.origin.x = vc.signInView.frame.origin.x
                visibleRect.origin.y = vc.signInContainerStackView.frame.origin.y
                visibleRect.size = vc.signInContainerStackView.frame.size
            } else {
                visibleRect.origin.x = vc.signUpView.frame.origin.x
                visibleRect.origin.y = vc.signUpContainerStackView.frame.origin.y
                visibleRect.size = vc.signUpContainerStackView.frame.size
            }
            vc.scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
        
        override func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) {
            vc.scrollView.contentInset.bottom = 0
        }
        
    }
    
}

