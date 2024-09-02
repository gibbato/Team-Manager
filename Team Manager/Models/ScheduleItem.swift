//
//  ScheduleItem.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/27/24.
//

import Foundation

struct ScheduleItem: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var type: ScheduleItemType
    var teamID: String
    var confirmations: [String: Bool] = [:]
    
    // Game-specific properties
    var location: String? = nil
    
    // Determine if the game is ongoing based on the current date and time
    var isGameOngoing: Bool {
        let now = Date()
        return now >= date && now <= Calendar.current.date(byAdding: .hour, value: 2, to: date)!
    }
}

enum ScheduleItemType: String, Codable {
    case game
    case practice
    case deadline
}
