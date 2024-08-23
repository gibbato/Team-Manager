//
//  Firebase.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/22/24.
//
import FirebaseCore
import FirebaseFirestore



class FirestoreService {
    private let db = Firestore.firestore()
    
    /*
     
     
     TEAM MEMBER FUNCTIONS
     
     
     */
    
    // Add a TeamMember document
    func addTeamMember(_ teamMember: TeamMember, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("teamMembers").document(teamMember.id).setData(from: teamMember)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
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
    
    func deleteTeamMember(_ teamMember: TeamMember, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("teamMembers").document(teamMember.id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    /*
     
     
     PLAYER FUNCTIONS
     
     
     */
    
    func updateTeamMemberProfileImage(teamMemberID: String, profileImageURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
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
    
}
