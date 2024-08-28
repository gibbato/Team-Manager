//
//  CreateOrJoinTeamView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/26/24.
//

import SwiftUI

import SwiftUI

struct CreateOrJoinTeamView: View {
    @EnvironmentObject private var authController: AuthController
    @StateObject private var viewModel = CreateOrJoinTeamViewModel()
    
    @State private var teamName: String = ""
    @State private var invitationCode: String = ""
    @State private var isJoining: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create or Join a Team")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Text field to create a new team
                TextField("Enter New Team Name", text: $teamName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let userID = authController.userId {
                        viewModel.createTeam(withName: teamName, managerID: userID)
                    }
                }) {
                    Text("Create Team")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(teamName.isEmpty) // Disable the button if the team name is empty
                
                Divider().padding()
                
                // Text field to join an existing team
                TextField("Enter Invitation Code", text: $invitationCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let userID = authController.userId {
                        viewModel.joinTeam(withCode: invitationCode, userID: userID)
                    }
                }) {
                    Text("Join Team")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(invitationCode.isEmpty) // Disable the button if the invitation code is empty
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationBarTitle("Team Manager", displayMode: .inline)
            .padding()
        }
        .onAppear {
            if let userID = authController.userId {
                viewModel.userID = userID
            }
        }
    }
    
}

#Preview {
CreateOrJoinTeamView()
.environmentObject(AuthController())
}

