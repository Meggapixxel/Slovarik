//
//  VC_Settings+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/12/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_SettingsItem: Equatable {
    
    var title: String { get }
    
}
extension VC_Settings: P_TableViewController {
    
    enum SettingsSections: Int, CaseIterable {
        
        case appearance = 0
        case account
        
        var numberOfSettings: Int {
            switch self {
            case .appearance: return AppearanceSection.allCases.count
            case .account: return AccountSection.allCases.count
            }
        }
        
        var title: String {
            switch self {
            case .appearance: return "APPEARANCE"
            case .account: return "ACCOUNT"
            }
        }
        
    }
    enum AppearanceSection: Int, CaseIterable, P_SettingsItem {
        
        case gradient = 0
        
        var title: String {
            switch self {
            case .gradient: return "Gradient colors"
            }
        }
        
    }
    enum AccountSection: Int, CaseIterable, P_SettingsItem {
        
        case logOut = 0, deleteAccount
        
        var title: String {
            switch self {
            case .logOut: return "Log out"
            case .deleteAccount: return "Delete account"
            }
        }
        
    }
    
    class Presenter: BaseTableViewControllerMultipleSectionPresenter<VC_Settings, LabelBlurBackgroundCell, String>, UITableViewDelegate {
        
        override var headerView: UIView? { vc.headerView.config { $0.backgroundColor = vc.tableView.separatorColor } }
        var footerView: UIView? { vc.footerView }
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            vc.tableView.contentInsetAdjustmentBehavior = .never
            vc.tableView.delegate = self
            vc.tableView.register(headerFooter: BlurSectionView.self)
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let settingsSection = SettingsSections(rawValue: indexPath.section) else { return }
            switch settingsSection {
            case .appearance:
                guard let appearanceSection = AppearanceSection(rawValue: indexPath.row) else { return }
                switch appearanceSection {
                case .gradient: vc.push { VC_SettingsGradient.newInstance }
                }
            case .account:
                guard let accountSection = AccountSection(rawValue: indexPath.row) else { return }
                switch accountSection {
                case .logOut: vc.logOut()
                case .deleteAccount: vc.deleteAccount()
                }
            }
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let settingsSection = SettingsSections(rawValue: section) else { return nil }
            return tableView.new(headerFooter: BlurSectionView.self, presenter: .init(title: settingsSection.title))
        }
        
    }
    
}
