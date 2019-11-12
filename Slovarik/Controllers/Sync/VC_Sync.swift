//
//  SyncVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/16/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_Sync: P_InitiableViewController {

    static var initiableResource: InitiableResource { .xib }
    
}

class VC_Sync: UIViewController {

    @Inject var database: RealtimeDatabase
    var successCallback: (([M_Tab]) -> ())?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sync()
    }
    
    private func sync() {
        database.tabs { [weak self] (tabs, error) in
            if let tabs = tabs {
                self?.successCallback?(tabs)
            } else {
                self?.showMessage(error?.localizedDescription, title: "Error")
            }
        }
    }
    
}
