//
//  SelectedTeamManager.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/27/24.
//

import Foundation
import Combine


class SelectedTeamManager: ObservableObject {
    @Published var currentTeam: Team? {
        didSet {
            saveCurrentTeam()
        }
    }

    private let teamKey = "selectedTeamID"
    private let firestoreService = FirestoreService()

    init() {
        loadCurrentTeam()
    }

    private func saveCurrentTeam() {
        guard let team = currentTeam else { return }
        UserDefaults.standard.set(team.id, forKey: teamKey)
    }

    func loadCurrentTeam() {
        if let teamID = UserDefaults.standard.string(forKey: teamKey) {
            firestoreService.fetchTeam(byID: teamID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let team):
                        self?.currentTeam = team
                    case .failure(let error):
                        print("Failed to load team: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    //  TODO: clear and re-set current team for when user signs out and back in under a different account
    
    func clearCurrentTeam() {
           UserDefaults.standard.removeObject(forKey: teamKey)
           currentTeam = nil
       }

    func updateCurrentTeam(_ team: Team) {
        currentTeam = team
    }
}
