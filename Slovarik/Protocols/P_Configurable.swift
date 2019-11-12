//
//  P_Configurable.swift
//  AllInOne
//
//  Created by Vadim Zhydenko on 16.10.2019.
//  Copyright © 2019 Zhydenko Developer. All rights reserved.
//

import Foundation

protocol P_Configurable { }

extension P_Configurable {
    
    @discardableResult
    func config(_ closure: (Self) -> ()) -> Self {
        closure(self)
        return self
    }
    
    static var name: String { String(describing: Self.self) }
    
}

extension NSObject: P_Configurable {
    
}
