//
//  P_BaseJellyViewController.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 4/29/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import UIKit
import Jelly

protocol P_BaseJellyViewController where Self: UIViewController {
    
    var jellyPresenter: P_BaseJellyPresenter { get }
    var dismissCompletion: (() -> ())? { get set }
    
}
