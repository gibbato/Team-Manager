//
//  Firebase.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//
import FirebaseCore
import FirebaseFirestore

import FirebaseCore
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    // Function to generate a unique invitation code
    private func generateUniqueInvitationCode(completion: @escaping (Result<String, Error>) -> Void) {
        let code = UUID().uuidString.prefix(8).uppercased() // Generate a random 8-character code
        db.collection("teams").whereField("invitationCode", isEqualTo: code).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if snapshot?.documents.isEmpty == true {
                completion(.success(String(code))) // Code is unique
            } else {
                self.generateUniqueInvitationCode(completion: completion) // Retry if not unique
            }
        }
    }

    // Function to create a new team
    func createTeam(name: String, managerID: String, completion: @escaping (Result<Void, Error>) -> Void) {
          generateUniqueInvitationCode { [weak self] codeResult in
              switch codeResult {
              case .success(let code):
                  let team = Team(
                      name: name,
                      managerID: managerID,
                      members: [TeamMemberInfo(id: managerID, role: "manager")],
                      memberIDs: [managerID], // Add managerID to memberIDs array
                      invitationCode: code
                  )
                  do {
                      try self?.db.collection("teams").document(team.id).setData(from: team)
                      completion(.success(()))
                  } catch let error {
                      completion(.failure(error))
                  }
              case .failure(let error):
                  completion(.failure(error))
              }
          }
      }

    // Function to join a team using an invitation code
    func joinTeam(byCode code: String, memberID: String, role: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("teams").whereField("invitationCode", isEqualTo: code).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = snapshot?.documents.first {
                let teamID = document.documentID
                let memberInfo = TeamMemberInfo(id: memberID, role: role)
                self.addMemberToTeam(teamID: teamID, memberInfo: memberInfo, completion: completion)
            } else {
                completion(.failure(NSError(domain: "No team found", code: 404, userInfo: nil)))
            }
        }
    }

    // Function to add a member to a team
    func addMemberToTeam(teamID: String, memberInfo: TeamMemberInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        let teamRef = db.collection("teams").document(teamID)
        teamRef.updateData([
            "members": FieldValue.arrayUnion([try! Firestore.Encoder().encode(memberInfo)]),
            "memberIDs": FieldValue.arrayUnion([memberInfo.id])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Function to fetch teams for a user by checking if the user ID is in the members array
    func fetchTeams(for userID: String, completion: @escaping (Result<[Team], Error>) -> Void) {
           db.collection("teams").whereField("memberIDs", arrayContains: userID).getDocuments { snapshot, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let documents = snapshot?.documents else {
                   completion(.success([])) // No teams found
                   return
               }

               let teams = documents.compactMap { document -> Team? in
                   return try? document.data(as: Team.self)
               }
               print(teams)
               completion(.success(teams))
           }
       }
    
    // Fetch the team by ID
       func fetchTeam(byID teamID: String, completion: @escaping (Result<Team, Error>) -> Void) {
           db.collection("teams").document(teamID).getDocument { document, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let document = document, document.exists, let team = try? document.data(as: Team.self) else {
                   completion(.failure(NSError(domain: "No team found", code: 404, userInfo: nil)))
                   return
               }

               completion(.success(team))
           }
       }

    // Function to fetch team members for a specific team
    func fetchTeamMembers(for teamID: String, completion: @escaping (Result<[TeamMemberInfo], Error>) -> Void) {
        db.collection("teams").document(teamID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists, let team = try? document.data(as: Team.self) else {
                completion(.failure(NSError(domain: "No team found", code: 404, userInfo: nil)))
                return
            }

            completion(.success(team.members))
        }
    }

    // Add a TeamMember document
    func addTeamMember(_ teamMember: TeamMember, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("teamMembers").document(teamMember.id).setData(from: teamMember)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    // Fetch all TeamMember documents
    func fetchTeamMembers(completion: @escaping (Result<[TeamMember], Error>) -> Void) {
        db.collection("teamMembers").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let teamMembers = documents.compactMap { document -> TeamMember? in
                return try? document.data(as: TeamMember.self)
            }
            completion(.success(teamMembers))
        }
    }
    
    

    // Delete a TeamMember document
    func deleteTeamMember(_ teamMember: TeamMember, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("teamMembers").document(teamMember.id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Update the profile image of a TeamMember document
    func updateTeamMemberProfileImage(teamMemberID: String, profileImageURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let teamMemberRef = db.collection("teamMembers").document(teamMemberID)
        
        teamMemberRef.updateData([
            "profilePictureURL": profileImageURL.absoluteString
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Fetch a TeamMember document by UID
    func fetchTeamMember(byUID uid: String, completion: @escaping (Result<TeamMember?, Error>) -> Void) {
           let teamMemberRef = db.collection("teamMembers").document(uid)
           
           teamMemberRef.getDocument { document, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               if let document = document, document.exists {
                   let teamMember = try? document.data(as: TeamMember.self)
                   completion(.success(teamMember))
               } else {
                   completion(.success(nil))
               }
           }
       }
    // Update a TeamMember document (for updating name, email, etc.)
    // Update only the fields that have changed
    func updateTeamMember(_ teamMemberID: String, with data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("teamMembers").document(teamMemberID).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
