import UIKit
import Jelly

protocol P_JellyViewControllerPresenter {
    
    static var animatorSize: PresentationSize { get }
    static var marginGuards: UIEdgeInsets { get }
    
}

extension P_JellyViewControllerPresenter {
    
    func updatePresentationSize(in jellyAnimator: P_JellyViewController) {
        try? jellyAnimator.animator?.updateSize(presentationSize: Self.animatorSize, duration: .medium)
        try? jellyAnimator.animator?.updateMarginGuards(marginGuards: Self.marginGuards, duration: .medium)
    }
    
}

extension P_JellyViewControllerPresenter {
    
    func updatePresentationSize(in vc: UIViewController?) {
        if let vc = vc?.navigationController as? P_JellyViewController {
            updatePresentationSize(in: vc)
        } else if let vc = vc as? P_JellyViewController {
            updatePresentationSize(in: vc)
        }
    }
    
    func viewDidAppear(in vc: UIViewController?) {
        updatePresentationSize(in: vc)
    }
    
}
