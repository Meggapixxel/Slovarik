//
//  UITextField+Array+NextResponder.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/11/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

extension UITextField {
    
    var textAsInt: Int? {
        return Int(textTrimmedNonEmpty ?? "")
    }
    
    var textAsEmail: String? {
        // TODO: - Some validations
        return textTrimmedNonEmpty
    }
    
    var textAsPassword: String? {
        // TODO: - Some validations
        return textTrimmedNonEmpty
    }
    
    var textTrimmedNonEmpty: String? {
        // TODO: - Some validations
        let t = text?.trimmingCharacters(in: .whitespaces) ?? ""
        return t.isEmpty == true ? nil : t
    }
    
}

extension Array where Element: UITextField {
    
    var isOk: Bool {
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
