import UIKit
import FirebaseAuth

protocol P_AuthCoordinator: class {
    
    func didAuth()
    
}
class AuthCoordinator: P_Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    private weak var delegate: P_AuthCoordinator?
    private let isInitial: Bool
    
    init(navigationController: UINavigationController, delegate: P_AuthCoordinator, isInitial: Bool) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.isInitial = isInitial
    }
    
    func start() {
        navigationController.setRootViewController(animated: !isInitial) {
            VC_Auth.newInstance?.config { $0.coordinatorDelegate = self }
        }
    }
    
}

extension AuthCoordinator: P_VCAuthDelegate {
    
    func didAuth() {
        delegate?.didAuth()
    }
    
}
