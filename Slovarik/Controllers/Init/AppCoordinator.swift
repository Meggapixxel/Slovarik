import UIKit
import FirebaseAuth

class AppCoordinator: P_Coordinator {
    
    enum Coordinator {
        case auth
        case main
    }
    
    // MARK: - Properties
    private let auth: Auth
    private let window: UIWindow
    private var childCoordinators = [Coordinator: P_Coordinator]()
    private let navigationController: UINavigationController
    
    init(window: UIWindow, navigationController: UINavigationController, auth: Auth) {
        self.window = window
        self.navigationController = navigationController
        self.window.rootViewController = navigationController
        self.auth = auth
    }
    
    func start() {
        if auth.currentUser != nil {
            showMain(isInitial: true)
        } else {
            showAuth(isInitial: true)
        }
    }
    
    private func showAuth(isInitial: Bool) {
        let coordinator = AuthCoordinator(navigationController: navigationController, delegate: self, isInitial: isInitial)
        childCoordinators[.auth] = coordinator
        coordinator.start()
    }
    
    private func showMain(isInitial: Bool) {
        let coordinator = MainCoordinator(navigationController: navigationController, delegate: self, isInitial: isInitial)
        childCoordinators[.main] = coordinator
        coordinator.start()
    }
    
}

extension AppCoordinator: P_AuthCoordinator {
    
    func didAuth() {
        childCoordinators[.auth] = nil
        showMain(isInitial: false)
    }
    
}

extension AppCoordinator: P_MainCoordinatorDelegate {
    
    func didSignOut() {
        childCoordinators[.main] = nil
        showAuth(isInitial: false)
    }
    
}
