import UIKit
import FirebaseAuth

protocol P_VCSettingsDelegate: class {
    
    func didSignOut()
    func showGradient()
    
}

extension VC_Settings: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_Settings: BaseSystemTransitionTableViewController {
 
    @Inject private var auth: Auth
    @Inject private var database: RealtimeDatabase
    
    private(set) lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: .scale1))
    private(set) lazy var footerView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    private(set) lazy var presenter = Presenter(vc: self, cellConfig: { .init(topText: $0) } )
    
    private lazy var tableViewObserver = tableView.observe(\.contentSize, options: [.initial, .new]) { [weak self] (tableView, _) in
        self?.presenter.updateFooterView()
    }
    
    weak var coordinatorDelegate: P_VCSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = tableViewObserver
        presenter.setItems(
            [
                AppearanceSection.allCases.compactMap { $0.title },
                AccountSection.allCases.compactMap { $0.title }
            ]
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.top = tableView.safeAreaInsets.top
    }
    
    func logOut() {
        do {
            try auth.signOut()
        } catch {
            return showError(error)
        }
        coordinatorDelegate?.didSignOut()
    }
    
    func deleteAccount() {
        database.removeTabs { [weak self] (error) in
            guard error == nil else { return { self?.showError(error) }() }
            self?.auth.currentUser?.delete { [weak self] (error) in
                guard error == nil else { return { self?.showError(error) }() }
                self?.coordinatorDelegate?.didSignOut()
            }
        }
    }
    
}
