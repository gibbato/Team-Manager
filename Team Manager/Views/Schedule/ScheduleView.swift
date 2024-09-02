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
    @State private var showingAddItemSheet = false

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if let currentTeam = selectedTeamManager.currentTeam {
                        // Calendar view
                        CalendarView(selectedDate: $viewModel.selectedDate, events: viewModel.eventDates)
                            .padding(.vertical)
                        
                        // Event list
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(viewModel.filteredScheduleItems) { item in
                                    NavigationLink(destination: viewModel.isGameOngoing(item) ? AnyView(OngoingGameView(scheduleItem: item)) : AnyView(ScheduleItemDetailView(scheduleItem: item))) {
                                        ScheduleItemCardView(item: item)
                                    }
                                }
                            }
                        }
                        .onAppear {
                            viewModel.loadScheduleItems(for: currentTeam.id)
                        }
                    } else {
                        Text("No team selected.")
                            .padding()
                    }
                }
                .navigationTitle("Schedule")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isUserManager() {
                            Button("Add Event") {
                                showingAddItemSheet = true
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
                        TeamDropdownMenuView(viewModel: viewModel, showingTeamSheet: $showingTeamSheet, isCreatingTeam: $isCreatingTeam)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    )
            }
        }
        .sheet(isPresented: $showingAddItemSheet) {
            if let currentTeam = selectedTeamManager.currentTeam {
                AddScheduleItemView(teamID: currentTeam.id, viewModel: viewModel)
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
        .onAppear {
            viewModel.updateFilteredScheduleItems()
        }
    }

    private func isUserManager() -> Bool {
        guard let userID = authController.userId,
              let team = selectedTeamManager.currentTeam else {
            return false
        }
        return team.members.contains(where: { $0.id == userID && $0.role == "manager" })
    }
}

#Preview {
    ScheduleView()
        .environmentObject(AuthController())
        .environmentObject(SelectedTeamManager())
}
