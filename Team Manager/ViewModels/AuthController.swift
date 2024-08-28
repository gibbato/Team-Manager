import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

enum AuthState {
    case undefined, authenticated, notAuthenticated
}

class AuthController: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authState: AuthState = .undefined
    @Published var userId: String? // To store the authenticated user's UID
    
    private let firestoreService = FirestoreService()

    init() {
        listenToAuthChanges()
    }
    
    func listenToAuthChanges() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.authState = .authenticated
                self.userId = user.uid
                self.createTeamMemberIfNeeded(for: user) // Ensure a TeamMember document exists
            } else {
                self.authState = .notAuthenticated
                self.userId = nil
            }
        }
    }
    
    func signUp() async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        print("\(email) signed up")
        self.userId = result.user.uid
        try await createTeamMemberIfNeeded(for: result.user)
    }
    
    func signIn() async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        print("\(email) signed in")
        self.userId = result.user.uid
        createTeamMemberIfNeeded(for: result.user) // Ensure a TeamMember document exists
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        print("\(email) signed out")
        self.userId = nil
        self.authState = .notAuthenticated
    }

    private func createTeamMemberIfNeeded(for user: User) {
        firestoreService.fetchTeamMember(byUID: user.uid) { result in
            switch result {
            case .success(let teamMember):
                if teamMember == nil {
                    // If no TeamMember exists, create one with default or provided values
                    let newTeamMember = TeamMember(
                        id: user.uid,
                        name: user.email ?? "No Name",
                        email: user.email ?? "No Email",
                        role: "Member", // Default role
                        isAvailable: true, // Default availability status
                        primaryPosition: "Unknown", // Default primary position
                        secondaryPosition: nil, // Optional secondary position
                        jerseyNumber: 0, // Default jersey number
                        throwingHand: "Unknown", // Default throwing hand
                        battingStance: "Unknown" // Default batting stance
                    )
                    self.firestoreService.addTeamMember(newTeamMember) { result in
                        switch result {
                        case .success:
                            print("TeamMember document created successfully")
                        case .failure(let error):
                            print("Failed to create TeamMember document: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("TeamMember document already exists")
                }
            case .failure(let error):
                print("Failed to fetch TeamMember document: \(error.localizedDescription)")
            }
        }
    }
}
