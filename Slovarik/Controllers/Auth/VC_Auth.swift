//
//  SignInVC.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/23/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

// MARK: - P_ViewController
extension VC_Auth: P_ViewController {
    
    static var initiableResource: InitiableResource { .xib }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_Auth: BaseSystemTransitionViewController {
    
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    
    @IBOutlet private(set) weak var signInView: UIView!
    @IBOutlet private(set) weak var signInContainerStackView: UIStackView!
    @IBOutlet private(set) weak var signInEmailTextField: UITextField!
    @IBOutlet private(set) weak var signInPasswordTextField: UITextField!
    @IBOutlet private(set) weak var signInButton: UIButton!
    
    @IBOutlet private(set) weak var signUpView: UIView!
    @IBOutlet private(set) weak var signUpContainerStackView: UIStackView!
    @IBOutlet private(set) weak var signUpEmailTextField: UITextField!
    @IBOutlet private(set) weak var signUpPasswordTextField: UITextField!
    @IBOutlet private(set) weak var signUpRepeatPasswordTextField: UITextField!
    @IBOutlet private(set) weak var signUpButton: UIButton!
    
    private var signInTextFields: [UITextField] {
        return [signInEmailTextField, signInPasswordTextField]
    }
    private var signUpTextFields: [UITextField] {
        return [signUpEmailTextField, signUpPasswordTextField, signUpRepeatPasswordTextField]
    }
    
    private(set) lazy var presenter = Presenter(vc: self)

}

// MARK: - Actions
extension VC_Auth {
    
    @IBAction private func didChangeTextFieldValue(_ sender: UITextField) {
        if signInTextFields.contains(sender) {
            signInButton.isEnabled = signInTextFields.isAllTextsTrimmedNonEmpty
        } else if signUpTextFields.contains(sender) {
            signUpButton.isEnabled = signUpTextFields.isAllTextsTrimmedNonEmpty
        }
    }
    
    @IBAction private func didTapSignIn() {
        guard let email = signInEmailTextField.textTrimmedNonEmpty, let password = signInPasswordTextField.textTrimmedNonEmpty else { return }
        let progressHud = MBProgressHUD.showAdded(to: view, animated: true)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            progressHud.hide(animated: true)
            guard let _ = user else { return self?.showMessage(error?.localizedDescription, title: "Error") ?? {}() }
            VC_Tabs().loadAsRoot()
        }
    }
    
    @IBAction private func didTapSignUp() {
        guard let email = signUpEmailTextField.textTrimmedNonEmpty,
            let password = signUpPasswordTextField.textTrimmedNonEmpty,
            let repeatPassword = signUpRepeatPasswordTextField.textTrimmedNonEmpty
            else { return }
        
        guard password == repeatPassword else { return showMessage("Passwords are not equal", title: "Error") }
        
        let progressHud = MBProgressHUD.showAdded(to: view, animated: true)
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            progressHud.hide(animated: true)
            guard let _ = user else { return self?.showMessage(error?.localizedDescription, title: "Error") ?? {}() }
            VC_Tabs().loadAsRoot()
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension VC_Auth: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if signInTextFields.contains(textField) {
            signInTextFields.nextBecomeFirstResponser(current: textField)
        } else if signUpTextFields.contains(textField) {
            signUpTextFields.nextBecomeFirstResponser(current: textField)
        }
        return true
    }
    
}
