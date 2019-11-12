import UIKit

protocol P_PresenterConfigurableViewController: P_KeyboardObservable where Self: UIViewController  {
    
    var basePresenter: P_ViewControllerPresenter { get }
    var isKeyboardObserving: Bool { get }
    
}

extension P_PresenterConfigurableViewController {
    
    var isKeyboardObserving: Bool { false }
    
}
