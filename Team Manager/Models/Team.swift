//
//  Team.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Foundation

struct Team: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var managerID: String
    var members: [String] = [] // Array of member IDs
    var invitationCode: String // Unique invitation code for joining the team
}
