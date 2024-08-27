//
//  ProfileController.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//


import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var profileImageURL: URL?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var teamMember: TeamMember?

    private let firestoreService = FirestoreService()

    func loadTeamMemberData(for teamMemberID: String) {
        isLoading = true
        firestoreService.fetchTeamMember(byUID: teamMemberID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let teamMember):
                    self?.teamMember = teamMember
                    self?.profileImageURL = teamMember?.profilePictureURL
                case .failure(let error):
                    self?.errorMessage = "Failed to load profile data: \(error.localizedDescription)"
                }
            }
        }
    }

    func getUserName() -> String {
        return teamMember?.name ?? "No Name"
    }

    func getUserEmail() -> String {
        return teamMember?.email ?? "No Email"
    }
    
    func getPrimaryPosition() -> String {
        return teamMember?.primaryPosition ?? "B"
    }
    
    func getSecondaryPosition() -> String {
        return teamMember?.secondaryPosition ?? "B"
    }
    
    func getJerseyNumber() -> Int {
        return teamMember?.jerseyNumber ?? 0
    }
    
    func getThrowingHand() -> String {
        return teamMember?.throwingHand ?? "Right"
    }
    
    func getBattingStance() -> String {
        return teamMember?.battingStance ?? "Right"
    }
    
    func isManager() -> Bool {
        return teamMember?.isManager ?? false
    }
    
    // Computed properties for shortened values
       var shortBattingStance: String {
           switch teamMember?.battingStance {
           case "Right":
               return "R"
           case "Left":
               return "L"
           case "Switch":
               return "S"
           default:
               return "R"
           }
       }
       
       var shortThrowingHand: String {
           switch teamMember?.throwingHand {
           case "Right":
               return "R"
           case "Left":
               return "L"
           default:
               return "R"
           }
       }



    // Helper function to perform partial updates
    private func updateTeamMemberData(_ teamMemberID: String, data: [String: Any]) {
        isLoading = true
        firestoreService.updateTeamMember(teamMemberID, with: data) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.loadTeamMemberData(for: teamMemberID)
                case .failure(let error):
                    self?.errorMessage = "Failed to update profile data: \(error.localizedDescription)"
                }
            }
        }
    }

    func updateUserName(_ newName: String) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["name": newName])
    }

    func updateUserEmail(_ newEmail: String) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["email": newEmail])
    }

    func updatePrimaryPosition(_ newPosition: String) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["primaryPosition": newPosition])
    }
    
    func updateSecondaryPosition(_ newPosition: String) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["secondaryPosition": newPosition])
    }
    
    func updateJerseyNumber(_ newNumber: Int) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["jerseyNumber": newNumber])
    }
    
    func updateThrowingHand(_ hand: String) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["throwingHand": hand])
    }
    
    func updateBattingStance(_ stance: String) {
        guard let teamMemberID = teamMember?.id else { return }
        updateTeamMemberData(teamMemberID, data: ["battingStance": stance])
    }

    func uploadAndSetProfileImage(_ image: UIImage, for teamMemberID: String) {
        isLoading = true
        ImageUploadService.shared.uploadProfileImage(image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    self?.firestoreService.updateTeamMemberProfileImage(teamMemberID: teamMemberID, profileImageURL: url) { updateResult in
                        self?.isLoading = false
                        switch updateResult {
                        case .success:
                            self?.profileImageURL = url
                        case .failure(let error):
                            self?.errorMessage = "Failed to update profile image: \(error.localizedDescription)"
                        }
                    }
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                }
            }
        }
    }
}
