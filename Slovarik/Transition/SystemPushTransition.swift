import UIKit

class SystemPushTransition: CustomTransition {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        toViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0.0)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                toViewController.view.frame = containerView.bounds
                fromViewController.view.frame = containerView.bounds.offsetBy(dx: -containerView.frame.size.width, dy: 0)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
}
