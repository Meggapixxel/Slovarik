import UIKit

class SystemPopTransition: CustomTransition {
    
    let interactionController: UIPercentDrivenInteractiveTransition?
    
    public init(type: TransitionType, duration: TimeInterval = 0.3, interactionController: UIPercentDrivenInteractiveTransition? = nil) {
        self.interactionController = interactionController
        super.init(type: type, duration: duration)
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else { return }
        
        let containerView = transitionContext.containerView
        if type == .navigation {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        toViewController.view.frame = containerView.bounds.offsetBy(dx: -containerView.frame.size.width, dy: 0)
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                toViewController.view.frame = containerView.bounds
                fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
}
