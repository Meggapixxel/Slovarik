import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum TransitionType {
        case navigation
        case modal
    }
    
    let type: TransitionType
    let duration: TimeInterval
    
    public init(type: TransitionType, duration: TimeInterval = 0.3) {
        self.type = type
        self.duration = duration
        
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("You have to implement this method for yourself!")
    }
    
}
