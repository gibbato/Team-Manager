//
//  ScheduleViewModel.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/26/24.
//

import Combine
import SwiftUI
import Foundation

class ScheduleViewModel: ObservableObject {
    @Published var userTeams: [Team] = []
    @Published var currentTeam: Team?
    @Published var scheduleItems: [ScheduleItem] = []
    @Published var showDropdown = false
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()

    // Load teams for the current user
    func loadTeams(for userID: String) {
          firestoreService.fetchTeams(for: userID) { [weak self] result in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let teams):
                      self?.userTeams = teams
                      self?.currentTeam = teams.first
                  case .failure(let error):
                      self?.errorMessage = "Failed to load teams: \(error.localizedDescription)"
                  }
              }
          }
      }

    // Create a new team
    func createTeam(withName teamName: String, managerID: String) {
        firestoreService.createTeam(name: teamName, managerID: managerID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadTeams(for: managerID)
                case .failure(let error):
                    self?.errorMessage = "Failed to create team: \(error.localizedDescription)"
                }
            }
        }
    }

    // Join a team using the invitation code
    func joinTeam(withCode invitationCode: String, userID: String) {
        firestoreService.joinTeam(byCode: invitationCode, memberID: userID, role: "player") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.loadTeams(for: userID)
                case .failure(let error):
                    self?.errorMessage = "Failed to join team: \(error.localizedDescription)"
                }
            }
        }
    }

    // Check if the current user is a manager of the current team
    var isManager: Bool {
        guard let currentTeam = currentTeam else { return false }
        return currentTeam.managerID == AuthController().userId
    }
    
    func loadScheduleItems(for teamID: String) {
        firestoreService.fetchScheduleItems(for: teamID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.scheduleItems = items.sorted(by: { $0.date < $1.date })
                case .failure(let error):
                    self?.errorMessage = "Failed to load schedule items: \(error.localizedDescription)"
                }
            }
        }
    }

       func confirmAttendance(for item: ScheduleItem, playerID: String, willAttend: Bool) {
           firestoreService.updateConfirmation(for: item.id, playerID: playerID, willAttend: willAttend) { [weak self] result in
               switch result {
               case .success:
                   if let index = self?.scheduleItems.firstIndex(where: { $0.id == item.id }) {
                       self?.scheduleItems[index].confirmations[playerID] = willAttend
                   }
               case .failure(let error):
                   print("Failed to update confirmation: \(error.localizedDescription)")
               }
           }
       }

       func addScheduleItem(title: String, date: Date, type: ScheduleItemType, teamID: String) {
           let newItem = ScheduleItem(title: title, date: date, type: type, teamID: teamID)
           firestoreService.addScheduleItem(newItem) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success:
                       self?.scheduleItems.append(newItem)
                   case .failure(let error):
                       print("Failed to add schedule item: \(error.localizedDescription)")
                   }
               }
           }
       }
    

}
