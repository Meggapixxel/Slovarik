import UIKit

protocol P_SyncCoordinatorDelegate: class {

    func didEndSync(tabs: [M_Tab])

}
class SyncCoordinator: P_Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    private weak var delegate: P_SyncCoordinatorDelegate?
    
    init(navigationController: UINavigationController, delegate: P_SyncCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    func start() {
        navigationController.present(
            VC_Sync().config { $0.coordinatorDelegate = self },
            animated: true
        )
    }
    
}

extension SyncCoordinator: P_VCSyncDelegate {
    
    func didEndSync(tabs: [M_Tab]) {
        navigationController.dismiss(animated: true) { [weak self] in
            self?.delegate?.didEndSync(tabs: tabs)
        }
    }
    
}
