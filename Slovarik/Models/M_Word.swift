//
//  M_Word.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/11/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import Firebase
import CodableFirebase

class M_Word: Codable {
    
    var id: String?
    let name: String
    let definition: String
    let createdAt: Date
    let updatedAt: Date
    
    init(name: String, definition: String) {
        self.name = name
        self.definition = definition
        let timestamp = Date()
        self.createdAt = timestamp
        self.updatedAt = timestamp
    }
    
}

extension M_Word: P_RealtimeModelWithId { }

extension M_Word: Equatable {
    
    static func == (lhs: M_Word, rhs: M_Word) -> Bool {
        lhs.id == rhs.id
    }
    
}
