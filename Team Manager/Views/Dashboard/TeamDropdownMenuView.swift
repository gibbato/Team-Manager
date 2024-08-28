//
//  TeamDropdownMenuView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/28/24.
//

import SwiftUI


struct TeamDropdownMenuView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @EnvironmentObject var selectedTeamManager: SelectedTeamManager
    @Binding var showingTeamSheet: Bool
    @Binding var isCreatingTeam: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(viewModel.userTeams) { team in
                Button(action: {
                    selectedTeamManager.updateCurrentTeam(team)  // Update the selected team
                    viewModel.currentTeam = team
                    viewModel.showDropdown = false
                }) {
                    Text(team.name)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(selectedTeamManager.currentTeam?.id == team.id ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(5)
                }
            }
            Divider()
            Button(action: {
                isCreatingTeam = true
                showingTeamSheet = true
                viewModel.showDropdown = false
            }) {
                Text("Create New Team")
                    .padding(.vertical, 5)
                    .padding(.horizontal)
            }
            Button(action: {
                isCreatingTeam = false
                showingTeamSheet = true
                viewModel.showDropdown = false
            }) {
                Text("Join a Team")
                    .padding(.vertical, 5)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    TeamDropdownMenuView(
        viewModel: ScheduleViewModel(),
        showingTeamSheet: .constant(false),
        isCreatingTeam: .constant(false)
    )
    .environmentObject(SelectedTeamManager())
}
