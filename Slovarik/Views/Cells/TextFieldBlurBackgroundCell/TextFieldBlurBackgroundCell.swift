//
//  TextFieldBlurBackgroundCell.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 7/24/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol TextFieldBlurBackgroundCellDelegate: class {
    
    func didEndEditing(_ textField: UITextField, atIndexPath indexPath: IndexPath)
    
}

class TextFieldBlurBackgroundCell: UITableViewCell {

    @IBOutlet private var cellBottomConstraint: [NSLayoutConstraint]!
    @IBOutlet private weak var textField: UITextField!
    
    private weak var delegate: TextFieldBlurBackgroundCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellBottomConstraint.forEach { $0.constant = Presenter.bottomSpacing }
    }
    
}

extension TextFieldBlurBackgroundCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let indexPath = selfIndexPath else { return }
        delegate?.didEndEditing(textField, atIndexPath: indexPath)
    }
    
}

extension TextFieldBlurBackgroundCell: P_PresenterConfigurableView {
    
    typealias PRESENTER = Presenter
    
}


extension TextFieldBlurBackgroundCell {
    
    class Presenter: P_ViewPresenter {
        
        static var bottomSpacing: CGFloat { .scale1 }
        
        let text: String?
        private(set) weak var delegate: TextFieldBlurBackgroundCellDelegate?
        
        init(text: String? = nil, delegate: TextFieldBlurBackgroundCellDelegate? = nil) {
            self.text = text
            self.delegate = delegate
        }
        
        func updateUI(_ view: TextFieldBlurBackgroundCell) {
            view.textField.text = text
            view.delegate = delegate
        }
        
    }
    
}
