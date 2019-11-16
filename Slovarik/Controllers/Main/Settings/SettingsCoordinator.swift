import UIKit
import FirebaseAuth

protocol P_SettingsCoordinatorDelegate: class {
    
    func didSignOut()
    
}

class SettingsCoordinator: P_Coordinator {
    
    private let navigationController: UINavigationController
    private weak var delegate: P_SettingsCoordinatorDelegate?
    
    init(navigationController: UINavigationController, delegate: P_SettingsCoordinatorDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    func start() {
        navigationController.push { VC_Settings.newInstance?.config { $0.coordinatorDelegate = self } }
    }
    
}

extension SettingsCoordinator: P_VCSettingsDelegate {
    
    func didSignOut() {
        delegate?.didSignOut()
    }
    
    func showGradient() {
        navigationController.push { VC_SettingsGradient.newInstance }
    }
    
}

extension SettingsCoordinator: P_VCSettingsGradientDelegate {
    
    func dismissSettingsGradient() {
        navigationController.popViewController(animated: true)
    }
    
    func presentColorPicker() {
        navigationController.present {
            JellyNavigationController()
                .config { $0.presenter.presentation(in: navigationController) }
                .push(animated: false) {
                    VC_ColorPicker.newInstance?.config {
                        $0.coordinatorDelegate = self
                    }
                }
        }
    }
    
}

extension SettingsCoordinator: P_VCColorPickerDelegate {
    
    func dismissColorPicker() {
        navigationController.dismiss(animated: true)
    }
    
    func didSelectColor(_ color: String) {
        guard let vc = navigationController.viewControllers.last as? VC_SettingsGradient else { return }
        navigationController.dismiss(animated: true) { [weak vc] in
            vc?.presenter.appendToAllColors(color)
        }
    }
    
}
