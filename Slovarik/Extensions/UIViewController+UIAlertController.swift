//
//  UIViewController+UIAlertController.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 26.10.2019.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAppError(_ appError: AppError, _ completion: (() -> ())? = nil) {
        showMessage(appError.localizedDescription, title: "Error", completion)
    }
    
    func showMessage(_ message: String? = nil, title: String, _ completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.doneAction(completion)
        present(alert, animated: true)
    }
    
    func showError(_ error: Error?, _ completion: (() -> ())? = nil) {
        showMessage(error?.localizedDescription, title: "Error", completion)
    }
    
    func showError(_ message: String?, completion: (() -> ())? = nil) {
        showMessage(message, title: "Error", completion)
    }
    
}

extension UIAlertController {
    
    @discardableResult
    func addAction(withTitle title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
        addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    @discardableResult
    func doneAction(_ action: (() -> ())? = nil) -> UIAlertController {
        return addAction(withTitle: "Done", style: .default) { (_) in action?() }
    }
    
    @discardableResult
    func cancelAction(_ action: (() -> ())? = nil) -> UIAlertController {
        return addAction(withTitle: "Cancel", style: .cancel) { (_) in action?() }
    }
    
    @discardableResult
    func retryAction(_ action: (() -> ())?) -> UIAlertController {
        guard let action = action else { return self }
        return addAction(withTitle: "Retry", style: .default)  { (_) in action() }
    }
    
}
