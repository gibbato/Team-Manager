//
//  Event.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Foundation

struct Event: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var location: String
    var attendees: [UUID] = [] // List of team members
    
   
}
