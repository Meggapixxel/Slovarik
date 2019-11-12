//
//  AppBottomDefaultBar.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/27/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_AppBottomDefaultBar: class {
    
    func addWord()
    func openSettings()
    func searchWords()
    
    var isEditing: Bool { get }
    func setEditing(_ isEditing: Bool, sender: UIButton)
    
}

class AppBottomDefaultBar: V_DesignableView {

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var addWordButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    
    weak var delegate: P_AppBottomDefaultBar?
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = .flexibleHeight
    }
    
    func setEnabled(_ value: Bool, except: [UIButton] = []) {
        [editButton!, addWordButton!, searchButton!, settingsButton!].forEach {
            if !except.contains($0) {
                $0.isEnabled = value
            }
        }
    }
 
}

extension AppBottomDefaultBar {
    
    @IBAction private func didTapEdit(_ sender: UIButton) {
        let isEditing = !(delegate?.isEditing == true)
        delegate?.setEditing(isEditing, sender: sender)
    }
    
    @IBAction private func didTapAddWord() {
        delegate?.addWord()
    }
    
    @IBAction private func didTapSearch() {
        delegate?.searchWords()
    }
    
    @IBAction private func didTapSettings() {
        delegate?.openSettings()
    }
    
}
