//
//  M_Tab.swift
//  Slovarik
//
//  Created by Vadim Zhydenko on 6/11/19.
//  Copyright © 2019 Vadim Zhydenko. All rights reserved.
//

import Firebase
import CodableFirebase

class M_Tab: Codable {
    
    var id: String?
    var name: String
    var position: Int
    let quizQuestion: String?
    let createdAt: Date
    let updatedAt: Date
    
    init(name: String, position: Int, quizQuestion: String?) {
        self.name = name
        self.position = position
        self.quizQuestion = quizQuestion
        let timestamp =  Date()
        self.createdAt = timestamp
        self.updatedAt = timestamp
    }
    
    static var `default`: M_Tab { return M_Tab(name: "Default", position: 0, quizQuestion: nil) } 
    
}
extension M_Tab: P_RealtimeModelWithId { }

extension M_Tab: Equatable {
    
    static func == (lhs: M_Tab, rhs: M_Tab) -> Bool {
        return lhs.id == rhs.id
    }
    
}
