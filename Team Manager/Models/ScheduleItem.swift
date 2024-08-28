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
    var teamID: String // The ID of the team this item belongs to
    var confirmations: [String: Bool] = [:] // Key: Player ID, Value: Confirmation status (true/false)
}

enum ScheduleItemType: String, Codable {
    case game
    case practice
    case deadline
}
