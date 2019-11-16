//
//  NewWordTabsVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/23/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

extension VC_TabSelection: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_TabSelection: UITableViewController, P_BaseJellyViewController {

    // MARK: BEGIN - BaseJellyViewController
    var jellyPresenter: P_BaseJellyPresenter { return presenter }
    var dismissCompletion: (() -> ())? = nil
    // MARK: END - BaseJellyViewController
    
    private(set) lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale))
    private(set) lazy var footerView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    private lazy var presenter = Presenter(vc: self, cellConfig: { .init(topText: $0.tab.name, isSelected: $0.isSelected) } )
    
    private var onTabChangeCallback: ((M_Tab) -> ())?
    
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
    
    func config(allTabs: [M_Tab], selectedTab: M_Tab, onTabChangeCallback: @escaping ((M_Tab) -> ())) {
        presenter.config(allTabs: allTabs, selectedTab: selectedTab)
        self.onTabChangeCallback = onTabChangeCallback
    }

}
extension VC_TabSelection {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.setSelectedTab(atIndex: indexPath.row)
        let selectedTab = presenter.items[indexPath.row]
        onTabChangeCallback?(selectedTab.tab)
        pop()
    }
    
}
