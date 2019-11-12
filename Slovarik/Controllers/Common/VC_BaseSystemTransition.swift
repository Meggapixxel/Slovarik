//
//  ViewController+SystemCustomTransition.swift
//  DictYourWay
//
//  Created by Vadim Zhydenko on 10/21/18.
//  Copyright © 2018 Vadim Zhydenko. All rights reserved.
//

import UIKit

class BaseSystemTransitionViewController: UIViewController, P_AppNavigationControllerDelegate {

    private(set) var leftEdgeInteractionController: LeftEdgeInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leftEdgeInteractionController = .init(viewController: self)
    }
    
}

class BaseSystemTransitionTableViewController: UITableViewController, P_AppNavigationControllerDelegate {
    
    private(set) var leftEdgeInteractionController: LeftEdgeInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftEdgeInteractionController = .init(viewController: self)
    }
    
}
