//
//  TabContentVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/16/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_TabWords: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_TabWords: UITableViewController {
    
    @Inject var database: RealtimeDatabase
    
    private(set) lazy var presenter = Presenter(vc: self, cellConfig: { .init(topText: $0.name, bottomText: $0.definition) } )
    
    private lazy var tableViewObserver = tableView.observe(\.contentSize, options: [.initial, .new]) { [weak self] (tableView, _) in
        self?.presenter.updateFooterView()
    }
    private(set) lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale))
    private(set) lazy var footerView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    var tab = M_Tab.default {
        didSet {
            guard let id = tab.id else { return }
            database.words(forTadId: id) { (words, error) in
                guard let words = words else { return self.showError(error) }
                self.presenter.setWords(words)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = tableViewObserver
    }
    
    func deleteWord(withId id: String, _ completion: @escaping () -> ()) {
        guard let tabId = tab.id else { return }
        database.removeWord(id: id, forTabId: tabId) { [weak self] (error) in
            guard error == nil else { return self?.showError(error) ?? {}() }
            completion()
        }
    }

}
