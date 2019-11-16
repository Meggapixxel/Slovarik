//
//  VC_NewWordTabs+Presenter.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/20/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

class TabSelection: Equatable {
    
    let tab: M_Tab
    var isSelected: Bool
    
    init(tab: M_Tab, isSelected: Bool) {
        self.tab = tab
        self.isSelected = isSelected
    }
    
    static func == (lhs: TabSelection, rhs: TabSelection) -> Bool {
        lhs.tab == rhs.tab
    }
    
}

extension VC_TabSelection: P_TableViewController {
    
    class Presenter: BaseJellyPresenter<VC_TabSelection>, P_TableViewControllerSingleSectionPresenter {
        
        typealias ITEM = TabSelection
        typealias CELL = LabelBlurBackgroundCell
        
        var footerViewBottomSpacing: CGFloat { 0 }
        
        var items = [ITEM]()
        var cellPresenters = [CELL.PRESENTER]()
        let cellConfig: (ITEM) -> (CELL.PRESENTER)
        var headerView: UIView? { vc.headerView.config { $0.backgroundColor = vc.tableView.separatorColor } }
        var footerView: UIView? { vc.footerView }
        
        required init(vc: VC_TabSelection, cellConfig: @escaping (ITEM) -> (CELL.PRESENTER)) {
            self.cellConfig = cellConfig
            super.init(vc: vc)
        }

        // MARK: BEGIN - Override BaseJellyPresenter
        override func initialUpdateUI() {
            super.initialUpdateUI()
            
            prepareTableViewControllerPresenter()
            vc.navigationItem.title = "ALL TABS"
            vc.tableView.contentInsetAdjustmentBehavior = .never
            vc.tableView.bounces = false
        }
        // MARK: END - Override BaseJellyPresenter
        
        func config(allTabs: [M_Tab], selectedTab: M_Tab) {
            setItems(allTabs.compactMap { TabSelection(tab: $0, isSelected: $0 == selectedTab) })
            guard let index = allTabs.firstIndex(of: selectedTab) else { return }
            setSelectedTab(atIndex: index)
        }
        
        func setSelectedTab(atIndex index: Int) {
            let newSelectedTab = items[index]
            guard !newSelectedTab.isSelected else { return }
            if let previousSelectedIndex = items.firstIndex(where: { $0.isSelected } ) {
                items[previousSelectedIndex].isSelected = false
                reloadItem(atIndex: previousSelectedIndex)
            }
            newSelectedTab.isSelected = true
            reloadItem(atIndex: index)
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            configuredCell(atIndexPath: indexPath)
        }
        
    }
    
}

extension VC_TabSelection.Presenter: P_TableViewResizableFooter {
    
}

