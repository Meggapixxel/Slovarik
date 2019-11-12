//
//  AppBottomSearchBar.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/16/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit

@IBDesignable class AppBottomSearchBar: V_DesignableView {
    
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var blurViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var blurViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var blurViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rootStackView: UIStackView!
    @IBOutlet private weak var rootStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rootStackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rootStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rootStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sortStackView: UIStackView!
    @IBOutlet private weak var sortSectionTitleLabel: UILabel!
    @IBOutlet private weak var sortSectionTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var sortSectionSortSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchStackView: UIStackView!
    @IBOutlet private weak var searchSectionTitleLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchSectionTypeSegmentedControl: UISegmentedControl!
    
    private(set) var state = State.expanded
    
    override var isFirstResponder: Bool {
        return searchBar.isFirstResponder
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: state.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        autoresizingMask = .flexibleHeight
    }
    
    func setState(_ state: State, animation: Animation) {
        self.state = state
        invalidateIntrinsicContentSize()
        updateUI(animation: animation)
    }
    
}

extension AppBottomSearchBar {
    
    enum Animation {
        
        case none
        case some(TimeInterval, UIView.AnimationOptions)
        
        var isAnimated: Bool {
            switch self {
            case .none: return false
            case .some: return true
            }
        }
        
        func animate(_ animationBlock: @escaping () -> (), completion: (() -> ())? = nil) {
            switch self {
            case .none:
                animationBlock()
                completion?()
            case .some(let duration, let options):
                UIView.animate(withDuration: duration, delay: 0, options: options, animations: animationBlock) { _ in
                    completion?()
                }
            }
        }
        
    }
    
    enum State {
        
        case collapsed, expanded
        
        var height: CGFloat {
            switch self {
            case .collapsed: return 30
            case .expanded: return 241
            }
        }
        
        var blurViewleadingTrailingConst: CGFloat {
            return 0
        }
        
        var blurViewBottomConst: CGFloat {
            return 0
        }
        
        var rootStackViewTopConst: CGFloat {
            switch self {
            case .collapsed: return 0
            case .expanded: return 16
            }
        }
        
        var rootStackViewBottomConst: CGFloat {
            switch self {
            case .collapsed: return UIApplication.safeAreaInsets.bottom
            case .expanded: return 16
            }
        }
        
        var rootStackViewleadingTrailingConst: CGFloat {
            switch self {
            case .collapsed: return 0
            case .expanded: return 16
            }
        }
        
        var isCollapsed: Bool {
            switch self {
            case .collapsed: return true
            default: return false
            }
        }
        
    }
    
}

extension AppBottomSearchBar {
    
    private func updateUI(animation: Animation) {
        let currentState = self.state
        let isAddonHidden = currentState.isCollapsed
        
        if isAddonHidden {
            self.sortStackView.isHidden = isAddonHidden
            self.searchSectionTitleLabel.isHidden = isAddonHidden
            self.searchSectionTypeSegmentedControl.isHidden = isAddonHidden
        }
        
        blurViewBottomConstraint.constant = currentState.blurViewBottomConst
        blurViewLeadingConstraint.constant = currentState.blurViewleadingTrailingConst
        blurViewTrailingConstraint.constant = currentState.blurViewleadingTrailingConst
        rootStackViewTopConstraint.constant = currentState.rootStackViewTopConst
        rootStackViewBottomConstraint.constant = currentState.rootStackViewBottomConst
        rootStackViewLeadingConstraint.constant = currentState.rootStackViewleadingTrailingConst
        rootStackViewTrailingConstraint.constant = currentState.rootStackViewleadingTrailingConst

        animation.animate({
            if !isAddonHidden  {
                self.sortStackView.isHidden = isAddonHidden
                self.searchSectionTitleLabel.isHidden = isAddonHidden
                self.searchSectionTypeSegmentedControl.isHidden = isAddonHidden
            }
            self.layoutIfNeeded()
        })
    }
    
}
