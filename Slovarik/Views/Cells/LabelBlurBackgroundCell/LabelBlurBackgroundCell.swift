//
//  LabelBlurBackgroundCell.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/22/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

class LabelBlurBackgroundCell: UITableViewCell {

    @IBOutlet private var cellBottomConstraint: [NSLayoutConstraint]!
    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellBottomConstraint.forEach { $0.constant = Presenter.bottomSpacing }
    }
    
}

extension LabelBlurBackgroundCell: P_PresenterConfigurableView {
    
    typealias PRESENTER = Presenter
    
}

extension LabelBlurBackgroundCell {
    
    class Presenter: P_ViewPresenter {
        
        static var bottomSpacing: CGFloat { .scale1 }
        
        var accessoryType: UITableViewCell.AccessoryType
        
        let topText: String?
        let topLabelLines: Int
        var isTopLabelHidden: Bool { topText == nil }
        
        let bottomText: String?
        let bottomLabelLines: Int
        var isBottomLabelHidden: Bool { bottomText == nil }

        init(topText: String? = nil, topLabelLines: Int = 1, bottomText: String? = nil, bottomLabelLines: Int = 1, accessoryType: UITableViewCell.AccessoryType = .none) {
            self.accessoryType = accessoryType
            self.topText = topText
            self.topLabelLines = topLabelLines
            self.bottomText = bottomText
            self.bottomLabelLines = bottomLabelLines
        }
        
        init(topText: String, isSelected: Bool) {
            self.accessoryType = isSelected ? .checkmark : .none
            self.topText = topText
            self.topLabelLines = 1
            self.bottomText = nil
            self.bottomLabelLines = 1
        }
        
        func updateUI(_ view: LabelBlurBackgroundCell) {
            view.accessoryType = accessoryType
            view.topLabel.text = topText
            view.topLabel.numberOfLines = topLabelLines
            view.topLabel.isHidden = isTopLabelHidden
            view.bottomLabel.text = bottomText
            view.bottomLabel.numberOfLines = bottomLabelLines
            view.bottomLabel.isHidden = isBottomLabelHidden
        }
        
    }
    
}
