import UIKit
import FirebaseAuth

protocol P_MainCoordinatorDelegate: class {
    
    func didSignOut()
    
}

class MainCoordinator: P_Coordinator {
    
    enum Coordinator {
        case sync
        case settings
    }
    
    private let navigationController: UINavigationController
    private var childCoordinators = [Coordinator: P_Coordinator]()
    private weak var delegate: P_MainCoordinatorDelegate?
    private let isInitial: Bool
    
    init(navigationController: UINavigationController, delegate: P_MainCoordinatorDelegate, isInitial: Bool) {
        self.navigationController = navigationController
        self.delegate = delegate
        self.isInitial = isInitial
    }
    
    func start() {
        navigationController.setViewControllers(
            [VC_Tabs().config { $0.coordinatorDelegate = self }],
            animated: !isInitial
        )
    }

}

extension MainCoordinator: P_VCTabsDelegate {
    
    func beginSync() {
        let coordinator = SyncCoordinator(navigationController: navigationController, delegate: self)
        childCoordinators[.sync] = coordinator
        coordinator.start()
    }
    
    func addTab(_ tabs: [M_Tab]) {
        navigationController.present {
            JellyNavigationController()
                .config { $0.presenter.presentation(in: navigationController) }
                .push(animated: false) {
                    VC_TabNew.newInstance?.config {
                        $0.coordinatorDelegate = self
                        $0.allTabs = tabs
                    }
                }
        }
    }
    
    func addWord(currentTab: M_Tab, tabs: [M_Tab]) {
        navigationController.present {
            JellyNavigationController()
                .config { $0.presenter.presentation(in: navigationController) }
                .push(animated: false) {
                    VC_WordNew.newInstance?.config {
                        $0.coordinatorDelegate = self
                        $0.selectedTab = currentTab
                        $0.allTabs = tabs
                    }
                }
        }
    }
    
    func editTabs(_ tabs: [M_Tab]) {
        navigationController.push {
            VC_TabsManager().config {
                $0.presenter.setItems(tabs)
                $0.coordinatorDelegate = self
            }
        }
    }
    
    func showSettings() {
        let coordinator = SettingsCoordinator(navigationController: navigationController, delegate: self)
        childCoordinators[.settings] = coordinator
        coordinator.start()
    }
    
}

extension MainCoordinator: P_SyncCoordinatorDelegate {
    
    func didEndSync(tabs: [M_Tab]) {
        childCoordinators[.sync] = nil
        guard let vc = navigationController.viewControllers.last as? VC_Tabs else {
            return
        }
        vc.endSync(tabs)
    }
    
}

extension MainCoordinator: P_SettingsCoordinatorDelegate {
    
    func didSignOut() {
        delegate?.didSignOut()
    }
    
}



extension MainCoordinator: VCTabsManagerDelegate {
    
    func didUpdateTabs(_ tabs: [M_Tab]) {
        let count = navigationController.viewControllers.count
        guard let vc = navigationController.viewControllers[count - 2] as? VC_Tabs else {
            return
        }
        navigationController.popViewController(animated: true)
        vc.setTabs(tabs)
    }
    
}

extension MainCoordinator: VCTabNewDelegate {
    
    func didAppendTab(_ tab: M_Tab) {
        guard let vc = navigationController.viewControllers.last as? VC_Tabs else {
            return
        }
        navigationController.dismiss(animated: true) {
            vc.appendNewTab(tab)
        }
    }
    
}

extension MainCoordinator: VCWordNewDelegate {
    
    func didAppendWord(_ word: M_Word, toTab tab: M_Tab) {
        guard let vc = navigationController.viewControllers.last as? VC_Tabs else {
            return
        }
        navigationController.dismiss(animated: true) {
            vc.appendNewWord(word, forTab: tab)
        }
    }
    
}
