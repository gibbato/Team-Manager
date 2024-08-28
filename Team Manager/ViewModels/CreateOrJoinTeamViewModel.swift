//
//  CreateOrJoinTeamViewModel.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/26/24.
//

import Combine
import SwiftUI

class CreateOrJoinTeamViewModel: ObservableObject {
    @Published var userID: String?
    @Published var errorMessage: String?
    private let firestoreService = FirestoreService()

    func createTeam(withName teamName: String, managerID: String) {
        firestoreService.createTeam(name: teamName, managerID: managerID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.errorMessage = "Team created successfully!"
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                }
            }
        }
    }

    func joinTeam(withCode invitationCode: String, userID: String) {
        firestoreService.joinTeam(byCode: invitationCode, memberID: userID, role: "player") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.errorMessage = "Joined team successfully!"
                case .failure(let error):
                    self?.errorMessage = "Failed to join team: \(error.localizedDescription)"
                }
            }
        }
    }
}
