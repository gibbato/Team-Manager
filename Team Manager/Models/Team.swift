//
//  Team.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Foundation

struct Team: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var managers: [String] = [] // Array of User IDs who are managers
    var players: [String] = [] // Array of User IDs who are players
    
}
