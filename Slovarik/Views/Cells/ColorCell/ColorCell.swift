//
//  ColorCell.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/30/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

class ColorCell: UITableViewCell {
    
    @IBOutlet private var cellBottomConstraint: [NSLayoutConstraint]!
    @IBOutlet private weak var colorNameLabel: UILabel!
    @IBOutlet private weak var colorVisualView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellBottomConstraint.forEach { $0.constant = Presenter.bottomSpacing }
    }
    
}

extension ColorCell: P_PresenterConfigurableView {
    
    typealias PRESENTER = Presenter
    
}

extension ColorCell {
    
    class Presenter: P_ViewPresenter {
        
        static var bottomSpacing: CGFloat { .scale1 }
        
        let colorNameText: String?
        let colorVisualRepresentation: UIColor
        
        init(colorNameText: String? = nil, colorVisualRepresentation: UIColor = .white) {
            self.colorNameText = colorNameText
            self.colorVisualRepresentation = colorVisualRepresentation
        }
        
        convenience init(hexColor: String) {
            self.init(
                colorNameText: hexColor,
                colorVisualRepresentation: hexColor.hexUIColor
            )
        }
        
        func updateUI(_ view: ColorCell) {
            view.colorNameLabel.text = colorNameText
            view.colorVisualView.backgroundColor = colorVisualRepresentation
        }
        
    }
    
}
