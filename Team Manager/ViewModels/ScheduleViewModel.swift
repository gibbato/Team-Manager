//
//  ScheduleViewModel.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/26/24.
//

import Foundation

class ScheduleViewModel: ObservableObject {
    @Published var currentTeam: Team?
    @Published var userTeams: [Team] = []
    @Published var isManager: Bool = false
    @Published var showDropdown: Bool = false

    private let firestoreService = FirestoreService()
    


    func loadTeams(for userID: String) {
        firestoreService.fetchTeams(for: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    self?.userTeams = teams
                    self?.currentTeam = teams.first
                    self?.isManager = teams.contains(where: { $0.managerID == userID })
                case .failure(let error):
                    print("Failed to load teams: \(error.localizedDescription)")
                }
            }
        }
    }
}
