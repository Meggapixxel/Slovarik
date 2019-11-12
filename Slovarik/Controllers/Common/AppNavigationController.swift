//
//  AppNavigationController.swift
//  DictYourWay
//
//  Created by Vadim Zhydenko on 10/17/18.
//  Copyright © 2018 Vadim Zhydenko. All rights reserved.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    init() {
        super.init(navigationBarClass: V_NavigationBarBlur.self, toolbarClass: nil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: V_NavigationBarBlur.self, toolbarClass: nil)
        viewControllers = [rootViewController]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
    }
    
}

// MARK: BEGIN - UINavigationControllerDelegate
extension AppNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push: return SystemPushTransition(type: .navigation)
        case .pop:
            if let appNavigationControllerDelegate = fromVC as? P_AppNavigationControllerDelegate {
                return SystemPopTransition(type: .navigation, interactionController: appNavigationControllerDelegate.leftEdgeInteractionController)
            }
            return SystemPopTransition(type: .navigation)
        default: return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animationController as? SystemPopTransition,
            let interactionController = animator.interactionController as? LeftEdgeInteractionController,
            interactionController.inProgress
            else { return nil }
        return interactionController
    }
    
}
// MARK: END - UINavigationControllerDelegate
