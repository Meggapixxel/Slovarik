import UIKit

protocol P_ViewControllerPresenter: P_KeyboardObservable {
    
    var isNavigationBarHidden: Bool { get }
    var isKeyboardObserving: Bool { get }
    
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    
    func initialUpdateUI()
    func runtimeUpdateUI()
    
}

class BaseViewControllerPresenter<T: P_PresenterConfigurableViewController>: NSObject, P_ViewControllerPresenter {
    
    var isNavigationBarHidden: Bool { false }
    var isKeyboardObserving: Bool { false }
    
    private(set) weak var vc: T!
    
    init(vc: T) {
        self.vc = vc
    }
    
    func viewDidLoad() {
        initialUpdateUI()
    }
    
    func viewWillAppear(_ animated: Bool) {
        if isKeyboardObserving { beginKeyboardObserving() }
        
        let navigationAction: (UINavigationController) -> () = {
            guard $0.isNavigationBarHidden != self.isNavigationBarHidden else { return }
            $0.setNavigationBarHidden(self.isNavigationBarHidden, animated: animated)
        }
        if let navigation = vc as? UINavigationController {
            navigationAction(navigation)
        } else if let navigation = vc.navigationController {
            navigationAction(navigation)
        }
    }
    
    func viewDidAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        if isKeyboardObserving { endKeyboardObserving() }
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func initialUpdateUI() {
        
    }
    
    func runtimeUpdateUI() {
        
    }
    
    // MARK: - P_KeyboardObservable
    func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        
    }
    
    func keyboardWillChangeFrame(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        
    }
    
    func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) {
        
    }
    
}
