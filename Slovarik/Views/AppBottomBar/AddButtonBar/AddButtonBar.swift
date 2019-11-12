//
//  AddButtonBar.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 9/14/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_AddButtonBarDelegate: class {
    
    func didTapAddButton()
    
}

class AddButtonBar: UIView {
    
    @IBOutlet private(set) weak var addButton: UIButton!
    
    weak var delegate: P_AddButtonBarDelegate?
    
    @IBAction private func didTapAddButton() {
        delegate?.didTapAddButton()
    }
    
}
