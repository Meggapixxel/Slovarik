//
//  P_BaseJellyPresenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/29/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

protocol P_BaseJellyPresenter: P_ViewControllerPresenter {
    
    var animator: Animator? { get set }
    var presentationUIConfiguration: PresentationUIConfiguration { get }
    var alignmentVertical: VerticalAlignment { get }
    var alignmentHorizontal: HorizontalAlignment { get }
    var directionShow: Direction { get }
    var directionDismiss: Direction { get }
    var animatorSize: PresentationSize { get }
    var marginGuards: UIEdgeInsets { get }
    var dragMode: DragMode { get }
    
    
    var animatorWidth: CGFloat { get }
    var animatorHeight: CGFloat { get }
    
    @discardableResult func presentation(in vc: UIViewController) -> Animator?
    
}

extension P_BaseJellyPresenter {
    
    var animatorSize: PresentationSize { .init(width: .custom(value: animatorWidth), height: .custom(value: animatorHeight)) }
    var presentationAlignment: PresentationAlignment { .init(vertical: alignmentVertical, horizontal: alignmentHorizontal) }
    
}

class BaseJellyPresenter<T: P_PresenterConfigurableViewController>: BaseViewControllerPresenter<T>, P_BaseJellyPresenter {
    
    var animator: Animator?

    var presentationUIConfiguration: PresentationUIConfiguration { .init() }
    var alignmentVertical: VerticalAlignment { .bottom }
    var alignmentHorizontal: HorizontalAlignment { .center }
    var directionShow: Direction { .bottom }
    var directionDismiss: Direction { .bottom }
    var marginGuards: UIEdgeInsets { .zero }
    var dragMode: DragMode { .canvas }
    
    var animatorWidth: CGFloat { UIScreen.main.bounds.width }
    var animatorHeight: CGFloat { UIScreen.main.bounds.height / 2 }
    
    // MARK: - before viewDidLoad
    @discardableResult func presentation(in vc: UIViewController) -> Animator? {
        animator = Animator(
            presentation: CoverPresentation(
                directionShow: directionShow,
                directionDismiss: directionDismiss,
                uiConfiguration: presentationUIConfiguration,
                size: animatorSize,
                alignment: presentationAlignment,
                marginGuards: marginGuards,
                interactionConfiguration: .init(
                    presentingViewController: vc,
                    dragMode: dragMode
                )
            )
        )
        animator?.prepare(presentedViewController: self.vc)
        return animator
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try? animator?.updateSize(presentationSize: animatorSize, duration: .normal)
        try? animator?.updateMarginGuards(marginGuards: marginGuards, duration: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard vc.isBeingDismissed == true else { return }
        animator = nil
    }

    override func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        var marginGuard = marginGuards
        marginGuard.bottom = height
        try? animator?.updateMarginGuards(marginGuards: marginGuard, duration: .custom(duration: duration))
        
        var newSize = animatorSize
        newSize.height = .custom(value: animatorHeight - vc.view.safeAreaInsets.bottom)
        try? animator?.updateSize(presentationSize: newSize, duration: .custom(duration: duration))
    }
    
    override func keyboardWillChangeFrame(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        
    }
    
    override func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) {
        let marginGuard = marginGuards
        try? animator?.updateMarginGuards(marginGuards: marginGuard, duration: .custom(duration: duration))
        let newSize = animatorSize
        try? animator?.updateSize(presentationSize: newSize, duration: .custom(duration: duration))
    }
    
}
