//
//  SignUpView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/26/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isManager: Bool = false
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    
    @EnvironmentObject private var authController: AuthController
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Create Account")
                .font(.largeTitle)
                .foregroundColor(Color("CharcoalBlack"))
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color("VeryLightGray"))
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .textCase(.lowercase)
                .padding()
                .background(Color("VeryLightGray"))
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color("VeryLightGray"))
                .cornerRadius(10)
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            // Slider Checkbox for Manager or Player
            HStack {
                Text("Player")
                    .foregroundColor(Color("CharcoalBlack"))
                Toggle(isOn: $isManager) {
                    Text(isManager ? "Manager" : "Player")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .toggleStyle(SliderToggleStyle())
                Text("Manager")
                    .foregroundColor(Color("CharcoalBlack"))
            }
            .padding()
            .background(Color("VeryLightGray"))
            .cornerRadius(10)
            .padding(.bottom, 20)
            
            Button(action: signUp) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("EmeraldGreen"))
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(Color("CharcoalBlack"))
                Button(action: {
                    dismiss() // Dismiss to go back to the AuthView
                }) {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(Color("DeepSkyBlue"))
                }
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color("WhiteSmoke"))
    }
    
    func signUp() {
        Task {
            do {
                authController.email = email
                authController.password = password
                
                try await authController.signUp()
                
                // Save additional data to Firestore
                let newTeamMember = TeamMember(
                    id: authController.userId ?? UUID().uuidString,
                    name: name,
                    email: email,
                    role: isManager ? "Manager" : "Player"
                )
                FirestoreService().addTeamMember(newTeamMember) { result in
                    switch result {
                    case .success:
                        print("User data saved successfully")
                        dismiss() // Navigate back to the login page after sign up
                    case .failure(let error):
                        errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    }
                }
                
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
}

struct SliderToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Rectangle()
                .fill(configuration.isOn ? Color("EmeraldGreen") : Color.gray)
                .frame(width: 50, height: 30)
                .cornerRadius(15)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .padding(4)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .animation(.spring(), value: configuration.isOn)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthController())
    }
}
