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
    
    func loadTeam(for userID: String) {
           firestoreService.fetchTeams(for: userID) { [weak self] result in
               switch result {
               case .success(let teams):
                   if let team = teams.first {
                       self?.loadTeamMembers(for: team)
                   } else {
                       self?.errorMessage = "No team found."
                   }
               case .failure(let error):
                   DispatchQueue.main.async {
                       self?.errorMessage = "Failed to load teams: \(error.localizedDescription)"
                   }
               }
           }
       }
    
    private func loadTeamMembers(for team: Team) {
        firestoreService.fetchTeamMembers(for: team) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let members):
                    self?.teamMembers = members
                case .failure(let error):
                    self?.errorMessage = "Failed to load team members: \(error.localizedDescription)"
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
