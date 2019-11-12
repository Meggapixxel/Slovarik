//
//  P_JellyNavigationController.swift
//  TopJobAgent
//
//  Created by Vadim Zhydenko on 3/14/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import Jelly

extension JellyNavigationController: P_PresenterConfigurableViewController {
    
    var basePresenter: P_ViewControllerPresenter { return presenter }
    
}

class JellyNavigationController: AppNavigationController, P_BaseJellyViewController {
    
    private(set) lazy var presenter = Presenter(vc: self)
    
    var jellyPresenter: P_BaseJellyPresenter { return presenter }
    var dismissCompletion: (() -> ())?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard isBeingDismissed else { return }
        presenter.animator = nil
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) { [weak self] in
            self?.dismissCompletion?()
            completion?()
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        guard let vc = viewController as? P_BaseJellyViewController else { return }
        vc.jellyPresenter.animator = presenter.animator
    }
    
}

extension JellyNavigationController {
    
    class Presenter: BaseJellyPresenter<JellyNavigationController> {
        
        
        
    }
    
}
