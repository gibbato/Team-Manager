//
//  AuthView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/21/24.
//

import SwiftUI

struct AuthView: View {
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    
    @EnvironmentObject private var authController: AuthController
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .foregroundColor(Color("CharcoalBlack"))
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                TextField("Email", text: $authController.email)
                    .textCase(.lowercase)
                    .padding()
                    .background(Color("VeryLightGray"))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $authController.password)
                    .textCase(.lowercase)
                    .padding()
                    .background(Color("VeryLightGray"))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                
                Button(action: signIn) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("EmeraldGreen"))
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                Button(action: signOut) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(Color("DeepSkyBlue"))
                }
                .padding(.top, 10)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(Color("CharcoalBlack"))
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(Color("DeepSkyBlue"))
                    }
                }
                .padding(.top, 20)
            }
            .padding()
            .background(Color("WhiteSmoke"))
        }
    }
    
    func signUp() {
        Task {
            do {
                try await authController.signUp()
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                try await authController.signIn()
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try authController.signOut()
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthController())
    }
}
