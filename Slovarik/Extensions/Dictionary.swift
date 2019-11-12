//
//  Dictionary.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/20/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import Foundation

extension Dictionary {
    
    subscript(i: Int) -> (key: Key, value: Value) {
        get { return self[index(startIndex, offsetBy: i)] }
    }
    
    mutating func removeValue(atIndex i: Int) {
        self.removeValue(forKey: self[index(startIndex, offsetBy: i)].key)
    }
    
}
