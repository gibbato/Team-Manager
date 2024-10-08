//
//  TeamController.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//

import Combine
import SwiftUI

class TeamController: ObservableObject {
    @Published var teams: [Team] = []
    @Published var teamMembers: [TeamMember] = []  // Use TeamMember instead of TeamMemberInfo
    @Published var selectedTeam: Team? {
        didSet {
            if let teamID = selectedTeam?.id {
                loadTeamMembers(for: teamID)
            }
        }
    }
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()

    func loadTeams(for userID: String) {
        firestoreService.fetchTeams(for: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    self?.teams = teams
                    self?.selectedTeam = teams.first
                case .failure(let error):
                    self?.errorMessage = "Failed to load teams: \(error.localizedDescription)"
                }
            }
        }
    }

    func loadTeamMembers(for teamID: String) {
        firestoreService.fetchTeamMembers(for: teamID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let memberInfos):
                    self?.fetchDetailedTeamMembers(memberInfos)
                case .failure(let error):
                    self?.errorMessage = "Failed to load team members: \(error.localizedDescription)"
                }
                }
            }
        }

    private func fetchDetailedTeamMembers(_ memberInfos: [TeamMemberInfo]) {
        let group = DispatchGroup()
        var fetchedMembers: [TeamMember] = []

        for memberInfo in memberInfos {
            group.enter()
            firestoreService.fetchTeamMember(byUID: memberInfo.id) { result in
                switch result {
                case .success(let member):
                    if let member = member {
                        fetchedMembers.append(member)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load team member: \(error.localizedDescription)"
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.teamMembers = fetchedMembers
        }
    }

    func addTeamMember(_ teamMemberInfo: TeamMemberInfo, to teamID: String) {
        firestoreService.addMemberToTeam(teamID: teamID, memberInfo: teamMemberInfo) { [weak self] result in
            switch result {
            case .success:
                self?.loadTeamMembers(for: teamID)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
