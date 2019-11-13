//
//  VC_TabsManager+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/20/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_TabsManager: P_TableViewController {
    
    class Presenter: BaseTableViewControllerSingleSectionPresenter<VC_TabsManager, TextFieldBlurBackgroundCell, M_Tab> {
        
        private(set) var deletedTabs = [M_Tab]()
        
        override var headerView: UIView? { vc.headerView.config { $0.backgroundColor = vc.tableView.separatorColor } }
        override var footerView: UIView? { vc.footerView }
        override var footerViewBottomSpacing: CGFloat { 0 }
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            vc.navigationItem.title = "TAB MANAGER"
            vc.navigationItem.rightBarButtonItem = vc.saveButton
            vc.tableView.contentInsetAdjustmentBehavior = .never
            vc.tableView.setEditing(true, animated: false)
            vc.tableView.delegate = self
        }
        
        // MARK: - Override UITableViewDataSource
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            items.count > 1
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete else { return }
            deletedTabs.append(items[indexPath.row])
            super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        }
        
    }
    
}

extension VC_TabsManager.Presenter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return items.count > 1 ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
