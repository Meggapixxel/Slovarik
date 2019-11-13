//
//  SettingsGradientVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/30/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_SettingsGradient: P_ViewController {

    static var initiableResource: InitiableResource { .manual }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_SettingsGradient: BaseSystemTransitionTableViewController {
    
    @Inject var gradientWindow: V_GradientWindow
    @Inject var appearanceManager: AppearanceManager
    
    private(set) lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
    private(set) lazy var headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: .scale1))
    private(set) lazy var footerView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    private lazy var bottomBar = AddButtonBar.instantiateFromNib().config { $0.delegate = self }
    
    private(set) lazy var presenter = Presenter(vc: self, cellConfig: { .init(hexColor: $0) } )
    
    private lazy var tableViewObserver = tableView.observe(\.contentSize, options: [.initial, .new]) { [weak self] (tableView, _) in
        self?.presenter.updateFooterView()
    }
    
    override var canBecomeFirstResponder: Bool { return true }
    override var inputAccessoryView: UIView? { return bottomBar }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = tableViewObserver
        presenter.setItems(
            [
                appearanceManager.gradientColors,
                appearanceManager.allColors
            ]
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.setEditing(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset.top = tableView.safeAreaInsets.top
        tableView.contentInset.bottom = max(tableView.safeAreaInsets.bottom, bottomBar.frame.height)
    }
    
}

extension VC_SettingsGradient: P_AddButtonBarDelegate {
    
    func didTapAddButton() {
        present {
            JellyNavigationController()
                .config { $0.presenter.presentation(in: self) }
                .push(animated: false) {
                    VC_ColorPicker.newInstance?.config {
                        $0.colorSelection = { hexString in
                            self.presenter.appendToAllColors(hexString)
                        }
                    }
                }
        }
    }
    
}

extension VC_SettingsGradient {
    
    @IBAction private func didTapSave() {
        let gradientColors = presenter.items[GradientSettingsItems.order.rawValue]
        let allColors = presenter.items[GradientSettingsItems.all.rawValue]
        appearanceManager.setColors(
            gradientColors: gradientColors,
            allColors: allColors
        )
        gradientWindow.setColors(gradientColors, animated: true)
//        gradientWindow.gradientView.setColors(
//            gradientColors.compactMap { $0.hexUIColor },
//            animated: true,
//            duration: Double(UINavigationController.hideShowBarDuration)
//        )
        pop()
    }
    
}
