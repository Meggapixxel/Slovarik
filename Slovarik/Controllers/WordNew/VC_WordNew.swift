//
//  NewTabVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/23/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension VC_WordNew: P_ViewController {

    static var initiableResource: InitiableResource { .xib }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_WordNew: UIViewController, P_BaseJellyViewController {
    
    @Inject var database: RealtimeDatabase

    @IBOutlet private(set) weak var rootStackView: UIStackView!
    @IBOutlet private(set) weak var nameTextField: UITextField!
    @IBOutlet private(set) weak var tabButton: UIButton!
    @IBOutlet private(set) weak var definitionTextView: UITextView!
    
    private(set) lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    private(set) lazy var saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
    
    // MARK: BEGIN - BaseJellyViewController
    var jellyPresenter: P_BaseJellyPresenter { return presenter }
    var dismissCompletion: (() -> ())? = nil
    // MARK: END - BaseJellyViewController
    
    private(set) lazy var presenter = Presenter(vc: self)
    
    var validationTextInputs: [P_TextInput] {
        return [nameTextField, definitionTextView]
    }
    
    var successCallback: ((M_Word, M_Tab) -> ())?
    var selectedTab = M_Tab.default
    var allTabs = [M_Tab]()

}

extension VC_WordNew {
    
    @IBAction private func didChangeTextField() {
        saveButton.isEnabled = validationTextInputs.isAllTextsTrimmedNonEmpty
    }
    
    @IBAction private func didTapTabSelection() {
        view.endEditing(true)
        push {
            VC_TabSelection.newInstance?.config {
                $0.config(allTabs: allTabs, selectedTab: selectedTab) { [weak self] newTab in
                    self?.selectedTab = newTab
                    self?.presenter.runtimeUpdateUI()
                }
            }
        }
    }
    
    @IBAction private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapSave() {
        guard let name = nameTextField.textTrimmedNonEmpty,
            let definition = definitionTextView.textTrimmedNonEmpty
            else { return showError("Fill all fields") }
        
        let selectedTab = self.selectedTab
        guard let tabId = selectedTab.id else { return }
        
        let localWord = M_Word(name: name, definition: definition)
        database.addWord(localWord, forTabId: tabId) { [weak self] (word, error) in
            guard let word = word else { return self?.showError(error) ?? {}() }
            self?.successCallback?(word, selectedTab)
            self?.dismiss(animated: true)
        }
    }
    
}

extension VC_WordNew: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = validationTextInputs.isAllTextsTrimmedNonEmpty
    }
    
}
