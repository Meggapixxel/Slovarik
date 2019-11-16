//
//  VC_ColorPicker.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 5/1/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

protocol P_VCColorPickerDelegate: class {
    
    func dismissColorPicker()
    func didSelectColor(_ color: String)
    
}

extension VC_ColorPicker: P_ViewController {

    static var initiableResource: InitiableResource { .xib }
    var basePresenter: P_ViewControllerPresenter { presenter }
    
}

class VC_ColorPicker: UIViewController, P_BaseJellyViewController {

    // MARK: BEGIN - BaseJellyViewController
    var jellyPresenter: P_BaseJellyPresenter { return presenter }
    var dismissCompletion: (() -> ())? = nil
    // MARK: END - BaseJellyViewController
    
    private(set) lazy var cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    private(set) lazy var saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
    @IBOutlet private weak var colorPickerView: ChromaColorPicker!
    
    private(set) lazy var presenter = Presenter(vc: self)
    weak var coordinatorDelegate: P_VCColorPickerDelegate?
    
}

extension VC_ColorPicker {
    
    @IBAction private func didTapCancel() {
        coordinatorDelegate?.dismissColorPicker()
    }
    
    @IBAction private func didTapSave() {
        coordinatorDelegate?.didSelectColor(colorPickerView.hexLabel.text ?? "#FFFFFF")
    }
    
}

extension VC_ColorPicker {
    
    class Presenter: BaseJellyPresenter<VC_ColorPicker> {
        
        override func initialUpdateUI() {
            super.initialUpdateUI()
            
            vc.navigationItem.leftBarButtonItem = vc.cancelButton
            vc.navigationItem.rightBarButtonItem = vc.saveButton
        }
        
    }
    
}
