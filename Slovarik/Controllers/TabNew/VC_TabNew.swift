//
//  NewTabVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/23/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_TabNew: P_ViewController {

    static var initiableResource: InitiableResource { .xib }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_TabNew: UIViewController, P_BaseJellyViewController {

    @Inject var database: RealtimeDatabase
    
    // MARK: BEGIN - BaseJellyViewController
    var jellyPresenter: P_BaseJellyPresenter { return presenter }
    var dismissCompletion: (() -> ())? = nil
    // MARK: END - BaseJellyViewController
    
    @IBOutlet private(set) weak var rootStackView: UIStackView!
    @IBOutlet private(set) weak var tabNameTextField: UITextField!
    @IBOutlet private(set) weak var quizQuestionTextField: UITextField!
    
    private(set) lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    private(set) lazy var saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
    
    private(set) lazy var presenter = Presenter(vc: self)
    var allTabs = [M_Tab]()
    var successCallback: ((M_Tab) -> ())?
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) { [weak self] in
            completion?()
            self?.dismissCompletion?()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        tabNameTextField.resignFirstResponder()
    }
    
}


// MARK: BEGIN - IBActions
extension VC_TabNew {
    
    @IBAction private func didChangeTextField() {
        saveButton.isEnabled = tabNameTextField.textTrimmedNonEmpty != nil
    }
    
    @IBAction private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapSave() {
        guard let name = tabNameTextField.textTrimmedNonEmpty else { return }
        
        if allTabs.contains(where: { $0.name.textTrimmedNonEmpty == name } ) {
            return showAppError(.tabExists)
        }
        
        let quizQuestion = quizQuestionTextField.textTrimmedNonEmpty
        database.tabs { [weak self] (tabs, error) in
            guard let tabs = tabs else { return self?.showError(error) ?? {}() }
            let localTab = M_Tab(name: name, position: tabs.count, quizQuestion: quizQuestion)
            self?.database.addTab(localTab) { [weak self] (newTab, error) in
                guard let newTab = newTab else { return self?.showError(error) ?? {}() }
                self?.successCallback?(newTab)
                self?.dismiss(animated: true)
            }
        }
    }
    
}
// MARK: END - IBActions
