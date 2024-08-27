//
//  CrewMember.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Foundation

struct TeamMember: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var role: String = "Player"
    var isManager: Bool = false
    var isAvailable: Bool = true
    var profilePictureURL: URL? = nil
    
    var primaryPosition: String?
    var secondaryPosition: String?
    var jerseyNumber: Int?
    var throwingHand: String?
    var battingStance: String?
    
    
    
}
    
   

