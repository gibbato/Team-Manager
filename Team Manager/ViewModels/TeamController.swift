//
//  TeamController.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Combine
import SwiftUI

class TeamController: ObservableObject {
    @Published var teamMembers: [TeamMember] = []
    @Published var errorMessage: String?
    private let firestoreService = FirestoreService()

    
    

    func loadTeamMembers() {
        firestoreService.fetchTeamMembers { [weak self] result in
            switch result {
            case .success(let teamMembers):
                DispatchQueue.main.async {
                    self?.teamMembers = teamMembers
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func addTeamMember(_ teamMember: TeamMember) {
        firestoreService.addTeamMember(teamMember) { [weak self] result in
            switch result {
            case .success:
                self?.loadTeamMembers()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func deleteTeamMember(_ teamMember: TeamMember) {
        firestoreService.deleteTeamMember(teamMember) { [weak self] result in
            switch result {
            case .success:
                self?.loadTeamMembers()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
     
}
