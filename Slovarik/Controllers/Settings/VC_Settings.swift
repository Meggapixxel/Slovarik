//
//  SettingsVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/21/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import FirebaseAuth

extension VC_Settings: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_Settings: BaseSystemTransitionTableViewController {
 
    @Inject var database: RealtimeDatabase
    
    private(set) lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale))
    private(set) lazy var footerView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    private(set) lazy var presenter = Presenter(vc: self, cellConfig: { .init(topText: $0) } )
    
    private lazy var tableViewObserver = tableView.observe(\.contentSize, options: [.initial, .new]) { [weak self] (tableView, _) in
        self?.presenter.updateFooterView()
    }
    
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
            try Auth.auth().signOut()
        } catch {
            return showError(error)
        }
        VC_Auth().loadAsRoot()
    }
    
    func deleteAccount() {
        database.removeTabs { [weak self] (error) in
            guard error == nil else { return { self?.showError(error) }() }
            Auth.auth().currentUser?.delete { [weak self] (error) in
                guard error == nil else { return { self?.showError(error) }() }
                VC_Auth().loadAsRoot()
            }
        }
    }
    
}
