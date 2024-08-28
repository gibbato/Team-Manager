//
//  Task.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Foundation

struct Todo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String
    var dueDate: Date? = nil
    var assignedTo: [UUID] = [] // List of TeamMember IDs
    var isCompleted: Bool = false
    
}
