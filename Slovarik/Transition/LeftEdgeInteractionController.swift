import UIKit

class LeftEdgeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var inProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    public init(viewController: UIViewController) {
        super.init()
        
        self.viewController = viewController
        self.setupGestureRecognizer(in: viewController.view)
    }
    
    private func setupGestureRecognizer(in view: UIView) {
        let edge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleEdgePan(_:)))
        edge.edges = .left
        view.addGestureRecognizer(edge)
    }
    
    @objc private func handleEdgePan(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent = translate.x / gesture.view!.bounds.size.width
        
        switch gesture.state {
        case .began:
            inProgress = true
            if let navigationController = viewController.navigationController {
                navigationController.popViewController(animated: true)
                return
            }
            viewController.dismiss(animated: true, completion: nil)
        case .changed: self.update(percent)
        case .cancelled:
            inProgress = false
            self.cancel()
        case .ended:
            inProgress = false
            if percent > 0.5 || gesture.velocity(in: gesture.view).x > 0 { self.finish() }
            else { self.cancel() }
        default: break
        }
    }
    
}
