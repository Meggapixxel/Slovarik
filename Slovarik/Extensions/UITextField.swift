//
//  UITextField+Array+NextResponder.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/11/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

@objc protocol P_TextInput where Self: UIView {
    var textToObserve: String { get }
    @discardableResult func becomeFirstResponder() -> Bool
    @discardableResult func resignFirstResponder() -> Bool
}
extension P_TextInput {
    
    var textTrimmedNonEmpty: String? {
        return textToObserve.textTrimmedNonEmpty
    }
    
}
extension UITextField: P_TextInput {
    var textToObserve: String { return text ?? "" }
}
extension UITextView: P_TextInput {
    var textToObserve: String { return text ?? "" }
}


extension Array where Element: P_TextInput {
    
    var isAllTextsTrimmedNonEmpty: Bool {
        return first(where: { $0.textTrimmedNonEmpty == nil } ) == nil
    }
    
    func nextBecomeFirstResponser(current textField: Element) {
        guard let index = self.firstIndex(of: textField) else { return }
        if index < (self.count - 1) {
            self[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
}
