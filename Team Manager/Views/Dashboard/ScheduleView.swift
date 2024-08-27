//
//  ScheduleView.swift
//  Team Manager
//
//  Created by Michael Gibson on 8/26/24.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @EnvironmentObject private var authController: AuthController
    @EnvironmentObject private var selectedTeamManager: SelectedTeamManager
    
    @State private var showingTeamSheet = false
    @State private var isCreatingTeam = false

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    // Placeholder for the main content of the ScheduleView
                    Text("Schedule content will go here.")
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle(selectedTeamManager.currentTeam?.name ?? "No Team")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text(selectedTeamManager.currentTeam?.name ?? "No Team")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .onTapGesture {
                                    viewModel.showDropdown.toggle()
                                }
                            Image(systemName: viewModel.showDropdown ? "chevron.up" : "chevron.down")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .onTapGesture {
                                    viewModel.showDropdown.toggle()
                                }
                        }
                    }
                }
            }
            
            if viewModel.showDropdown {
                Color.white
                    .ignoresSafeArea()
                    .opacity(0.95)
                    .overlay(
                        DropdownMenu(viewModel: viewModel, showingTeamSheet: $showingTeamSheet, isCreatingTeam: $isCreatingTeam)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    )
            }
        }
        .onAppear {
            if let userID = authController.userId {
                viewModel.loadTeams(for: userID)
            }
        }
        .sheet(isPresented: $showingTeamSheet) {
            if isCreatingTeam {
                CreateTeamView { teamName in
                    if let userID = authController.userId {
                        viewModel.createTeam(withName: teamName, managerID: userID)
                    }
                }
            } else {
                JoinTeamView { invitationCode in
                    if let userID = authController.userId {
                        viewModel.joinTeam(withCode: invitationCode, userID: userID)
                    }
                }
            }
        }
    }
}

struct DropdownMenu: View {
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
    ScheduleView()
        .environmentObject(AuthController())
        .environmentObject(SelectedTeamManager())
}
