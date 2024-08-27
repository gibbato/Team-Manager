//
//  JoinTeamView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/27/24.
//

import SwiftUI



struct JoinTeamView: View {
    @State private var invitationCode: String = ""
    var onJoin: (String) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Join a Team")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Enter Invitation Code", text: $invitationCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    onJoin(invitationCode)
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
            }
            .padding()
            .navigationBarTitle("Join Team", displayMode: .inline)
        }
    }
}

#Preview {
    JoinTeamView { _ in }
}
