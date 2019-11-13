//
//  SettingsGradientVC+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 5/5/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_SettingsGradient: P_TableViewController {
    
    enum GradientSettingsItems: Int, CaseIterable { case order = 0, all }
    
    class Presenter: BaseTableViewControllerMultipleSectionPresenter<VC_SettingsGradient, ColorCell, String>, UITableViewDelegate {
        
        override var headerView: UIView? { vc.headerView.config { $0.backgroundColor = vc.tableView.separatorColor } }
        var footerView: UIView? { vc.footerView }
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            vc.navigationItem.rightBarButtonItem = vc.saveButton
            vc.tableView.contentInsetAdjustmentBehavior = .never
            vc.tableView.delegate = self
            vc.tableView.register(headerFooter: BlurSectionView.self)
            vc.tableView.allowsSelectionDuringEditing = true
        }
        
        func appendToAllColors(_ hexString: String) {
            appendItem(hexString, section: GradientSettingsItems.all.rawValue)
        }
        
        // MARK: - UITableViewDelegate
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 44
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let settingsItems = GradientSettingsItems(rawValue: section) else { return nil }
            switch settingsItems {
            case .order: return tableView.new(headerFooter: BlurSectionView.self, presenter: .init(title: "ORDER"))
            case .all: return tableView.new(headerFooter: BlurSectionView.self, presenter: .init(title: "SAVED"))
            }
        }
        
        func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            return indexPath.section == GradientSettingsItems.all.rawValue
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(#function)
            defer { tableView.deselectRow(at: indexPath, animated: true) }
            guard let settingsItems = GradientSettingsItems(rawValue: indexPath.section) else { return }
            let item = items[indexPath.section][indexPath.row]
            switch settingsItems {
            case .order: break
            case .all: appendItem(item, section: GradientSettingsItems.order.rawValue)
            }
        }
        
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            guard let settingsItems = GradientSettingsItems(rawValue: indexPath.section) else { return .none }
            switch settingsItems {
            case .order: return items[indexPath.section].count > 1 ? .delete : .none
            case .all: return .delete
            }
        }
        
        func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }
        
        func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
            return sourceIndexPath.section != proposedDestinationIndexPath.section ? sourceIndexPath : proposedDestinationIndexPath
        }
        
    }
    
}
