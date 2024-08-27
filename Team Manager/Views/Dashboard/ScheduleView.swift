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

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    // Main content of the ScheduleView goes here
                    Text("Schedule content will go here.")
                        .padding()
                    
                    Spacer()
                }
                .navigationTitle(viewModel.currentTeam?.name ?? "No Team")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text(viewModel.currentTeam?.name ?? "No Team")
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
            
            // Overlay the dropdown menu when it is active
            if viewModel.showDropdown {
                Color.white
                    .ignoresSafeArea()
                    .opacity(0.95)  // Ensure it is not see-through
                    .overlay(
                        DropdownMenu(viewModel: viewModel)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    )
            }
        }
        .onAppear {
            if let userID = authController.userId {
                viewModel.loadTeams(for: userID)
            }
        }
    }
}

struct DropdownMenu: View {
    @ObservedObject var viewModel: ScheduleViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(viewModel.userTeams) { team in
                Button(action: {
                    viewModel.currentTeam = team
                    viewModel.showDropdown = false
                }) {
                    Text(team.name)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(viewModel.currentTeam?.id == team.id ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(5)
                }
            }
            Divider()
            if viewModel.isManager {
                Button(action: {
                    // Action to create a new team
                    viewModel.showDropdown = false
                }) {
                    Text("Create New Team")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
                Button(action: {
                    // Action to join another team
                    viewModel.showDropdown = false
                }) {
                    Text("Join Another Team as Player")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
            } else {
                Button(action: {
                    // Action to join another team
                    viewModel.showDropdown = false
                }) {
                    Text("Join Another Team")
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                }
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
}
