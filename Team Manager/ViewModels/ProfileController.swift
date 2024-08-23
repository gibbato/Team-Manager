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

    private let firestoreService = FirestoreService()

    func loadTeamMemberData(for teamMemberID: String) {
        isLoading = true
        firestoreService.fetchTeamMember(byUID: teamMemberID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let teamMember):
                    self?.profileImageURL = teamMember?.profilePictureURL
                case .failure(let error):
                    self?.errorMessage = "Failed to load profile data: \(error.localizedDescription)"
                }
            }
        }
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
