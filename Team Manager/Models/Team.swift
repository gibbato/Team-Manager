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
    var members: [TeamMemberInfo] = [] // Array of TeamMemberInfo to include roles
    var memberIDs: [String] = [] // Array of member IDs for easy querying
    var invitationCode: String // Unique invitation code for joining the team
}

struct TeamMemberInfo: Codable, Identifiable {
    var id: String
    var role: String // Role of the team member (e.g., "manager", "player")
}
