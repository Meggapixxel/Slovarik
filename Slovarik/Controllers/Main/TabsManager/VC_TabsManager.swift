//
//  VC_TabsManager.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/20/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol VCTabsManagerDelegate: class {
    
    func didUpdateTabs(_ tabs: [M_Tab])
    
}

extension VC_TabsManager: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_TabsManager: BaseSystemTransitionTableViewController {
    
    @Inject private var database: RealtimeDatabase
    
    private(set) lazy var presenter = Presenter(vc: self, cellConfig: { .init(text: $0.name, delegate: self) } )
    private(set) lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEdit))
    private(set) lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale))
    private(set) lazy var footerView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    weak var coordinatorDelegate: VCTabsManagerDelegate?
    
    private lazy var tableViewObserver = tableView.observe(\.contentSize, options: [.initial, .new]) { [weak self] (tableView, _) in
        self?.presenter.updateFooterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = tableViewObserver
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.top = tableView.safeAreaInsets.top
    }
    
}

extension VC_TabsManager {
    
    @objc private func saveEdit() {
        view.endEditing(true)
        let tabIdsToDelete = presenter.deletedTabs.compactMap { $0.id }
        let tabsToUpdate = presenter.items
        tabsToUpdate.enumerated().forEach { $0.element.position = $0.offset }
        database.removeTabs(ids: tabIdsToDelete) { (error) in
            guard error == nil else { return self.showError(error) }
            self.database.updateTabs(tabsToUpdate) { (error) in
                guard error == nil else { return self.showError(error) }
                self.coordinatorDelegate?.didUpdateTabs(tabsToUpdate)
            }
        }
    }
    
}

extension VC_TabsManager: TextFieldBlurBackgroundCellDelegate {
    
    func didEndEditing(_ textField: UITextField, atIndexPath indexPath: IndexPath) {
        defer { presenter.reloadItem(atIndex: indexPath.row) }
        guard let newTabName = textField.textTrimmedNonEmpty else { return }
        let currentTab = presenter.items[indexPath.row]
        if presenter.items.contains(where: { $0 != currentTab && $0.name == newTabName } ) {
            showAppError(.tabExists)
        } else {
            presenter.items[indexPath.row].name = newTabName
        }
    }
    
}
