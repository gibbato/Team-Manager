//
//  Message.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String = UUID().uuidString
    var senderID: UUID
    var content: String
    var timestamp: Date = Date()
    

}
