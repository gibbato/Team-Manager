//
//  CreateTeamView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/27/24.
//

import SwiftUI

import SwiftUI

struct CreateTeamView: View {
    @State private var teamName: String = ""
    var onCreate: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create a New Team")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Enter Team Name", text: $teamName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    onCreate(teamName)
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

                Spacer()
            }
            .padding()
            .navigationBarTitle("New Team", displayMode: .inline)
        }
    }
}

#Preview {
    CreateTeamView { _ in }
}
