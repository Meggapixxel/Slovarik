//
//  SyncVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/16/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_VCSyncDelegate: class {
    
    func didEndSync(tabs: [M_Tab])
    
}

extension VC_Sync: P_InitiableViewController {

    static var initiableResource: InitiableResource { .xib }
    
}

class VC_Sync: UIViewController {

    @Inject private var database: RealtimeDatabase
    
    weak var coordinatorDelegate: P_VCSyncDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sync()
    }
    
    private func sync() {
        database.tabs { [weak self] (tabs, error) in
            guard let `self` = self else { return }
            if let tabs = tabs {
                self.coordinatorDelegate?.didEndSync(tabs: tabs)
            } else {
                self.showMessage(error?.localizedDescription, title: "Error")
            }
        }
    }
    
}
