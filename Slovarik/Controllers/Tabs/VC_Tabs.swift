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

// MARK: - P_ViewController
extension VC_Tabs: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_Tabs: TabmanViewController {
    
    @Inject var gradientWindow: V_GradientWindow
    @Inject var database: RealtimeDatabase
    
    private(set) lazy var presenter = Presenter(vc: self)
    
    
    private(set) lazy var bar = V_TMBar()
    private(set) lazy var barAddTabButton = V_TMButton(
        image: UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .large)
        )!,
        target: self,
        action: #selector(didTapAddTab)
    )
    private(set) lazy var barEditTabsButton = V_TMButton(
        image: UIImage(
            systemName: "gear",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .large)
        )!,
        target: self,
        action: #selector(didTapEditTabs)
    )
    private(set) lazy var barCancelSearchButton = V_TMButton(
        image: UIImage(
            systemName: "xmark",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        )!,
        target: self,
        action: #selector(didTapCancelSearch)
    )
    private var viewControllers = [VC_TabWords]() {
        didSet { gradientWindow.resizeGradientView(withMultiplier: CGFloat(viewControllers.count)) }
    }
    
    var isSearch = false
    var keyboardHeight: CGFloat = 0
    
    
    private(set) lazy var bottomDefaultBar = AppBottomDefaultBar.instantiateFromNib().config { $0.delegate = self }
    private(set) lazy var bottomSearchBar = AppBottomSearchBar.instantiateFromNib().config { $0.setState(.collapsed, animation: .none) }
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? { return isSearch ? bottomSearchBar : bottomDefaultBar }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginSync()
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
        gradientWindow.scrollGradientView(toPagePosition: pagePosition)
    }
    
    
    private func appendNewTab(_ newTab: M_Tab) {
        guard let newTabContentVC = VC_TabWords.newInstance else { return }
        viewControllers.append(newTabContentVC.config { $0.tab = newTab } )
        insertPage(at: viewControllers.count - 1, then: .scrollToUpdate)
    }
    
    private func appendNewWord(_ newWord: M_Word, forTab tab: M_Tab) {
        guard let vc = viewControllers.first(where: { $0.tab == tab } ) else { return }
        vc.presenter.appendNewWord(newWord)
        // TODO: - Scroll to visible new word
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        currentViewController?.setEditing(editing, animated: animated)
    }
    
}


// MARK: - Sync
extension VC_Tabs {
    
    func beginSync() {
        let vc = VC_Sync().config { vc in
            vc.successCallback = { [weak self] tabs in
                self?.endSync(tabs.sorted(by: { $0.position < $1.position } ))
                vc.dismiss(animated: true) {
                    self?.becomeFirstResponder()
                }
            }
        }
        present(vc, animated: true)
    }
    
    func endSync(_ tabs: [M_Tab]) {
        viewControllers = tabs.compactMap { tab in
            VC_TabWords.newInstance?.config { $0.tab = tab }
        }
        reloadData()
    }
    
}


// MARK: - Actions
extension VC_Tabs {
    
    @objc private func didTapAddTab() {
        present {
            JellyNavigationController()
                .config { $0.presenter.presentation(in: self) }
                .push(animated: false) {
                    VC_TabNew.newInstance?.config {
                        $0.successCallback = self.appendNewTab
                        $0.allTabs = self.viewControllers.compactMap { $0.tab }
                    }
                }
        }
    }
    
    @objc private func didTapEditTabs() {
        let tabs = viewControllers.compactMap { $0.tab }
        push {
            VC_TabsManager().config {
                $0.presenter.setItems(tabs)
                $0.editCallback = {
                    self.database.tabs { [weak self] (tabs, error) in
                          if let tabs = tabs {
                            self?.viewControllers = tabs.compactMap { tab in
                                VC_TabWords.newInstance?.config { $0.tab = tab }
                            }
                            self?.reloadData()
                        } else {
                            self?.showMessage(error?.localizedDescription, title: "Error")
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didTapCancelSearch() {
        resignFirstResponder()
        barEditTabsButton.isHidden = false
        barCancelSearchButton.isHidden = true
        barAddTabButton.isEnabled = isSearch
        isSearch.toggle()
        bottomSearchBar.setState(.collapsed, animation: .some(0.3, .curveEaseIn))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.becomeFirstResponder()
            self.view.setNeedsLayout()
        }
    }
    
    @objc private func didTapSettings() {
        push { VC_Settings.newInstance }
    }
    
    @IBAction private func didTapProfile() {
        push { VC_Auth.newInstance }
    }
    
}


// MARK: - TMBarDataSource
extension VC_Tabs: TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        TMBarItem(title: viewControllers[index].tab.name)
    }
    
}


// MARK: - PageboyViewControllerDataSource
extension VC_Tabs: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil
    }
    
}


extension VC_Tabs: P_AppBottomDefaultBar {
    
    func addWord() {
        guard let currentTabContentVC = currentViewController as? VC_TabWords else { return }
        present {
            JellyNavigationController()
                .config { $0.presenter.presentation(in: self) }
                .push(animated: false) {
                    VC_WordNew.newInstance?.config {
                        $0.selectedTab = currentTabContentVC.tab
                        $0.successCallback = self.appendNewWord
                        $0.allTabs = self.viewControllers.compactMap { $0.tab }
                    }
                }
        }
    }
    
    func searchWords() {
        resignFirstResponder()
        barEditTabsButton.isHidden = true
        barCancelSearchButton.isHidden = false
        barAddTabButton.isEnabled = isSearch
        isSearch.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.becomeFirstResponder()
            self.view.setNeedsLayout()
        }
    }
    
    func openSettings() {
        push { VC_Settings.newInstance }
    }
    
    func setEditing(_ isEditing: Bool, sender: UIButton) {
        setEditing(isEditing, animated: true)
        barAddTabButton.isEnabled = !isEditing
        barEditTabsButton.isEnabled = !isEditing
        bottomDefaultBar.setEnabled(!isEditing, except: [sender])
    }
    
}
