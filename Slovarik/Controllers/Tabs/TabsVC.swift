//
//  TabsVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/16/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

extension VC_Tabs: P_BaseViewController {
    
    var basePresenter: P_BasePresenter { return presenter }
    
}


class VC_Tabs: TabmanViewController {
    
    private let presenter = Presenter()
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppearanceManager.recovered.blurStyle.statusBarStyle
    }
    private(set) lazy var bar = AppTMBar()
    private(set) lazy var barAddTabButton = TabManButton(image: #imageLiteral(resourceName: "icon_plus"), target: self, action: #selector(didTapAddTab))
    private(set) lazy var barSearchButton = TabManButton(image: #imageLiteral(resourceName: "icon_search"), target: self, action: #selector(didTapSearch))
    private var viewControllers = [TabContentVC]()
    
    private var isSearch = false
    let bottomDefaultBar = AppBottomDefaultBar.instantiateFromNib()
    let bottomSearchBar = AppBottomSearchBar.instantiateFromNib()
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? { return isSearch ? bottomSearchBar : bottomDefaultBar }
    
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(in: self)
        
        beginSync()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear(animated)
    }
    
    override func keyboardWillShow(withHeight keyboardHeight: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        guard isSearch, bottomSearchBar.isFirstResponder, keyboardHeight > bottomSearchBar.frame.height else { return }
        self.keyboardHeight = keyboardHeight - bottomSearchBar.frame.height
        bottomSearchBar.setState(.expanded, animation: .some(duration, options))
        view.setNeedsLayout()
    }
    
    override func keyboardWillHide(withDuration duration: TimeInterval, options: UIView.AnimationOptions) {
        guard bottomSearchBar.state != .collapsed else { return }
        bottomSearchBar.setState(.collapsed, animation: .some(duration, options))
        self.keyboardHeight = 0
        view.setNeedsLayout()
    }
    
    override func calculateRequiredInsets() -> Insets {
        let accessoryViewHeight = (inputAccessoryView?.frame ?? .zero).height
        return Insets(
            barInsets: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: accessoryViewHeight - view.safeAreaInsets.bottom + keyboardHeight,
                right: 0
            ),
            safeAreaInsets: view.safeAreaInsets
        )
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollTo: position, direction: direction, animated: animated)
        scrollGradientView(toPagePosition: position.x)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: Int, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        viewControllers.forEach { $0.setEditing(false, animated: false) }
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        scrollGradientView(toPagePosition: CGFloat(index))
        currentViewController?.setEditing(isEditing, animated: true)
    }
    
    func scrollGradientView(toPagePosition pagePosition: CGFloat) {
        UIApplication.gradientWindow.scrollGradientView(toPagePosition: pagePosition)
    }
    
    
    private func appendNewTab(_ newTab: M_Tab) {
        guard let newTabContentVC = TabContentVC.newInstance else { return }
        viewControllers.append(newTabContentVC.config { $0.tab = newTab } )
        insertPage(at: viewControllers.count - 1, then: .scrollToUpdate)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        currentViewController?.setEditing(editing, animated: animated)
    }
    
}


// MARK: BEGIN - Sync
extension VC_Tabs {
    
    func beginSync() {
        VC_Sync.presentNewInstance(in: self) { vc in
            vc.successCallback = { [weak self] tabs in
                self?.endSync(tabs.sorted(by: { $0.position < $1.position } ))
                vc.dismiss(animated: true) {
                    self?.becomeFirstResponder()
                }
            }
        }
    }
    
    func endSync(_ tabs: [M_Tab]) {
        (UIApplication.appDelegate.window as? AppGradientWindow)?.reloadData(withMultiplier: CGFloat(tabs.count))
        viewControllers = tabs.compactMap { tab in
            TabContentVC.newInstance?.config { $0.tab = tab }
        }
        reloadData()
    }
    
}
// MARK: END - Sync


// MARK: BEGIN - Actions
extension VC_Tabs {
    
    @objc private func didTapAddTab() {
        NewTabVC.presentNewInstance(in: self) { (vc) in
            vc.presentation(in: self)
            vc.successCallback = self.appendNewTab
        }
    }
    
    @objc private func didTapSearch() {
        resignFirstResponder()
        isSearch.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.becomeFirstResponder()
            self.view.setNeedsLayout()
        }
    }
    
    @objc private func didTapSettings() {
        SettingsVC.presentNewInstance(in: navigationController)
    }
    
    @IBAction private func didTapProfile() {
        VC_Auth.presentNewInstance(in: navigationController)
    }
    
}
// MARK: BEGIN - Actions


// MARK: BEGIN - TMBarDataSource
extension VC_Tabs: TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: viewControllers[index].tab.name)
    }
    
}
// MARK: END - TMBarDataSource


// MARK: BEGIN - PageboyViewControllerDataSource
extension VC_Tabs: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
// MARK: END - PageboyViewControllerDataSource



extension VC_Tabs: P_AppBottomDefaultBar {
    
    func addWord() {
        guard let currentTabContentVC = currentViewController as? TabContentVC else { return }
        NewWordNavigationController.presentNewInstance(in: self) { vc in
            vc.presentation(in: self)
            guard let newWordVC = vc.viewControllers.first as? NewWordVC else { return }
            newWordVC.selectedTab = currentTabContentVC.tab
            newWordVC.successCallback = currentTabContentVC.presenter.appendNewWord
        }
    }
    
    func openSettings() {
        SettingsVC.presentNewInstance(in: navigationController)
    }
    
    func setEditing(_ isEditing: Bool) {
        setEditing(isEditing, animated: true)
    }
    
}
